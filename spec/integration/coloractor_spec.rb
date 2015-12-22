require 'spec_helper'
require 'benchmark'

describe Coloractor do

  let(:do_extract) { Coloractor.extract_colors(filename) }

  context "with jpg file" do
    let(:filename) { 'spec/fixtures/files/godaddy.jpg' }

    it "extracts dominant colors from image file" do
      result = do_extract
      expected_colors = ["#E6F8C9", "#B7CF8F", "#EF9653", "#EDF8E7", "#967052"]
      expect(result.dominant_colors).to eq(expected_colors)
    end

    it "extracts background color from image file" do 
      result = do_extract
      background_color = '#96C14E'
      expect(result.background_color).to eq(background_color)
    end
  end

  context "with non transparent png file" do
    let(:filename) { 'spec/fixtures/files/pro.png' }

    it "extracts background color from image file" do
      result = do_extract
      background_color = '#FFFFFF'
      expect(result.background_color).to eq(background_color)
    end
  end

end
