require 'spec_helper'
require 'benchmark'

describe Coloractor do

  let(:filename)   { 'spec/fixtures/files/godaddy.jpg' }
  let(:do_extract) { Coloractor.extract_colors(filename) }

  it "extracts dominant colors from image file" do
    result = do_extract
    expected_colors = ["#B7CF8F", "#E6F8C9", "#F5FEEB", "#F29753", "#957052"]
    expect(result.dominant_colors).to eq(expected_colors)
  end

  it "extracts background color from image file" do 
    result = do_extract
    background_color = '#96C14E'
    expect(result.background_color).to eq(background_color)
  end

end
