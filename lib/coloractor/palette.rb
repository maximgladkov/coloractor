require 'color' 
require 'mini_magick'

class Coloractor::Palette

  N_QUANTIZED = 100
  MIN_DISTANCE = 10.0
  MIN_SATURATION = 0.05
  MIN_PROMINENCE = 0.01
  MAX_COLORS = 5
  # BACKGROUND_PROMINENCE = 0.5

  def self.build_from_file(filename)
    image = open_image(filename)
     
    unless image_mode_is_rgb?(image)
      image = convert_image_mode_to_rgb(image)
    end

    image = trim_image(image)
    image = reduce_colors_in_image(image, N_QUANTIZED)
    pixels = get_pixels_from_image(image)
    pixels_count = pixels.size

    canonical_colors  = { '#FFFFFFFF' => '#FFFFFFFF', '#000000FF' => '#000000FF' }
    aggregated_colors = { '#FFFFFFFF' => 0, '#000000FF' => 0 }
    
    grouped_pixels = Hash[ *pixels.group_by{ |i| i }.map{|k,v| [k, v.count] }.flatten ]
    sorted_pixels = grouped_pixels.sort_by{ |color, count| -count }
    
    sorted_pixels.each do |(color, count)|
      if aggregated_colors.include?(color)
        aggregated_colors[color] += count
      else
        closest_color = find_closest_color(color, aggregated_colors)
      
        if closest_color && distance(color, closest_color) < MIN_DISTANCE
          aggregated_colors[closest_color] += count
          canonical_colors[color]           = closest_color
        else
          aggregated_colors[color] = count
          canonical_colors[color]  = color
        end
      end
    end

    sorted_aggregated_colors = aggregated_colors.sort_by{ |color, count| -count }
    background_color = detect_background_color(image, pixels, sorted_aggregated_colors, canonical_colors)
    
    colors = sorted_aggregated_colors.map{ |(color, count)| color }.select{ |c| background_color.nil? || c != background_color }
    
    saturated_colors = colors.select{ |color| calculate_saturation(color) >= MIN_SATURATION }
    if background_color && calculate_opacity(background_color).zero?
      background_color = nil
    end

    if saturated_colors.size > 0
      colors = saturated_colors
    else
      colors = [ colors.first ]
    end

    palette_colors = []
    colors.each do |color|
      if calculate_prominence(color, sorted_aggregated_colors, pixels_count) >= calculate_prominence(colors.first, sorted_aggregated_colors, pixels_count) * MIN_PROMINENCE
        palette_colors << color
      end

      break if palette_colors.size >= MAX_COLORS
    end

    new(palette_colors.map{ |c| c[0..6] }, background_color ? background_color[0..6] : nil)
  end

  attr_reader :colors, :background_color

  def initialize(colors, background_color)
    @colors           = colors
    @background_color = background_color
  end

  private

  def self.open_image(filename)
    MiniMagick::Image.open(filename)
  end

  def self.image_mode_is_rgb?(image)
    true # image.colorspace =~ /rgb/i
  end

  def self.convert_image_mode_to_rgb(image)
    image.tap{ |i| i.colorspace "sRGB" }
  end

  def self.trim_image(image)
    image.tap(&:trim)
  end

  def self.reduce_colors_in_image(image, max_colors)
    image.tap{ |i| i.combine_options{ |o| o.dither 'None'; o.colors max_colors } }
  end

  def self.get_pixels_from_image(image)
    output = `convert -dither None -colors 100 #{ image.path } txt:-`
    output.scan(/#[0-9a-fA-F]{6,8}/).flatten.map{ |color| color }
  end

  def self.find_closest_color(color, colors)
    color, _ = colors.min_by do |(c, _)| 
      distance(c, color)
    end

    color
  end
  
  def self.distance(color1, color2)
    color1_transparency = calculate_opacity(color1)
    color2_transparency = calculate_opacity(color2)
    Color::RGB.new.delta_e94(Color::RGB.by_hex(color1[1..6]).to_lab, Color::RGB.by_hex(color2[1..6]).to_lab) + (color1_transparency - color2_transparency).abs
  end

  def self.calculate_opacity(color)
    color.size > 7 ? color[7..8].to_i(16) : 255
  end

  def self.detect_background_color(image, pixels, colors, canonical_colors)
    # TODO: remove this if not needed
    # if colors.first && calculate_prominence(colors.first.first, colors, pixels.size) >= BACKGROUND_PROMINENCE
    #   return colors.first.first
    # end

    width, height = get_image_size(image)
  
    points = [
      [0,         0], 
      [0,         height / 2], 
      [0,         height - 1], 
      [width - 1, height - 1],
      [width - 1, height / 2],
      [width - 1, 0], 
      [width / 2, 0]
    ]

    edge_pixels = points.map{ |(left, top)| pixels[top * width + left] }
    grouped_edge_pixels = Hash[ *edge_pixels.group_by{|i| i}.map{|k,v| [k, v.count] }.flatten ]
    sorted_pixels = grouped_edge_pixels.sort_by{ |color, count| count }.reverse
    majority_color, majority_count = sorted_pixels.first
    if majority_count >= 3
      canonical_colors[majority_color]
    else
      nil
    end
  end

  def self.get_image_size(image)
    image['dimensions']
  end

  def self.calculate_prominence(color, colors, pixels_count)
    colors = Hash[ *colors.flatten ] if colors.is_a?(Array)

    colors[color] / pixels_count.to_f
  end

  def self.calculate_saturation(color)
    Color::RGB.by_hex(color[1..6]).to_hsl.saturation / 100
  end

end
