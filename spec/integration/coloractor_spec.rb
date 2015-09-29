require 'spec_helper'

describe Coloractor do

  let(:filename)   { 'spec/fixtures/files/godaddy.jpg' }
  let(:do_extract) { Coloractor.extract_colors(filename) }

  it "extracts dominant colors from image file" do
    result = do_extract
    expected_colors = ['#d5ddb6', '#bd8d67', '#655242']  
    expect(result.dominant_colors).to eq(expected_colors)
  end

  it "extracts background color from image file" do 
    result = do_extract
    background_color = '#97c24e'
    expect(result.background_color).to eq(background_color)
  end

end
