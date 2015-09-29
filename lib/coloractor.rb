require 'rubypython' 
require 'color'

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
	  output = colorific.extract_colors(@filename).to_s

		@dominant_colors  = extract_colors_from_output(output)
    @background_color = extract_background_color_from_output(output)
	end
 
	private

	def extract_colors_from_output(output)
		colors_string	= output.scan(/colors\=\[(.+?)\]/).first.first
    colors_array  = extract_colors_array_from_string(colors_string)

		colors_array.map{ |array| build_color_from_array(array) } 
	end

	def extract_background_color_from_output(output)
		background_color_string = output.scan(/bgcolor\=(.+)\)/).first.first
		background_color_array  = extract_colors_array_from_string(background_color_string).first

		build_color_from_array(background_color_array) if background_color_array
	end

	def extract_colors_array_from_string(string)
    string.scan(/(\d+), (\d+), (\d+)/)
	end

	def build_color_from_array(array)
		Color::RGB.new( *array.map(&:to_i) ).html()
	end

  def colorific
    return @@colorific if defined?(@@colorific) && @@colorific
		
		RubyPython.start
		setup_python_system_path
		@@colorific = RubyPython.import('colorific')
		define_finalizer
		@@colorific
	end

  def setup_python_system_path
		sys = RubyPython.import('sys')
		sys.path.append("#{ File.dirname(__dir__) }/vendor/colorific/")
	end

	def define_finalizer
		ObjectSpace.define_finalizer(@@colorific, proc { RubyPython.stop })
	end

end
  
