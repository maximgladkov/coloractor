class Coloractor

  def self.extract_colors(filename)
    new(filename).tap do |instance|
      instance.extract_colors
    end
  end

  attr_reader :dominant_colors, :background_color

  def initialize(filename)
    @filename        = filename
    @dominant_colors = []
  end

  def extract_colors
    palette = Coloractor::Palette.build_from_file(@filename)

    @dominant_colors  = palette.colors
    @background_color = palette.background_color
  end

end

require 'coloractor/palette'  
