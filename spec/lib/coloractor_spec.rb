require 'spec_helper'

describe Coloractor do

  let(:filename)   { 'spec/fixtures/files/mimi.jpg' }
  let(:do_extract) { Coloractor.extract_colors(filename) }

  it "extracts dominant colors" do
    result = do_extract
    expected_colors = ["#FBCB44", "#FAE8A8", "#FEF8D5", "#C7E8FA"]
    expect(result.dominant_colors).to eq(expected_colors)
  end

  context "image has background" do 
    it "extracts background color" do
      result = do_extract
      expected_background_color = '#84C3EC'
      expect(result.background_color).to eq(expected_background_color)
    end
  end

  context "image has no background" do
    let(:filename) { 'spec/fixtures/files/chrome.png' }

    it "sets background color to nil" do
      result = do_extract
      expect(result.background_color).to be_nil
    end
  end

  context "image has white background" do
    let(:filename) { 'spec/fixtures/files/apple.jpg' }

    it "sets background color to white" do
      result = do_extract
      expected_background_color = '#FFFFFF'
      expect(result.background_color).to eq(expected_background_color)
    end
  end

end
