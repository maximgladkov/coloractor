require 'spec_helper'

describe Coloractor do

  let(:filename)   { 'spec/fixtures/files/mimi.jpg' }
  let(:do_extract) { Coloractor.extract_colors(filename) }

  it "extracts dominant colors" do
    result = do_extract
    expected_colors = ['#f6d565', '#fff2b6', '#c2e6f9']
    expect(result.dominant_colors).to eq(expected_colors)
  end

  context "image has background" do 
    it "extracts background color" do
      result = do_extract
      expected_background_color = '#84c3ec'
      expect(result.background_color).to eq(expected_background_color)
    end
  end

  shared_examples "background color is nil" do
    it "sets background color to nil" do
      result = do_extract
      expect(result.background_color).to be_nil
    end
  end

  context "image has no background" do
    let(:filename) { 'spec/fixtures/files/chrome.png' }

    include_examples "background color is nil" 
  end

  context "image has white background" do
    let(:filename) { 'spec/fixtures/files/apple.jpg' }

    include_examples "background color is nil"
  end

  it "stops Python interpreter when object is finalized" do
    expect(RubyPython).to receive(:stop)
    result = do_extract
    Coloractor.class_variable_set(:@@colorific, nil)
    ObjectSpace.garbage_collect
  end

end
