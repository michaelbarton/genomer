require 'spec_helper'

describe Genomer::Plugin do

  describe "#to_class_name" do

    it "should dash separated words to camel case" do
      described_class.to_class_name('words-with-dashes').should == "WordsWithDashes"
    end

  end

end
