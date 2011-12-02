require 'spec_helper'

describe Genomer::Plugin do

  describe "#plugins" do

    before do
      mock(Bundler).setup do
        mock!.gems{ gems }
      end
    end

    describe "where a single genomer plugin is specified" do

      let(:gems) do
        [Gem::Specification.new do |s|
          s.name = 'genomer-plugin-simple'
        end]
      end

      it "should return the genomer plugin" do
        described_class.plugins.should == gems
      end

    end

    describe "where no gems at all are specified" do

      let(:gems) do
        []
      end

      it "should return an empty array" do
        described_class.plugins.should be_empty
      end

    end

    describe "where one plugin and one non-plugin are specified" do

      let(:gems) do
        [Gem::Specification.new{|s| s.name = 'genomer-plugin-simple' },
         Gem::Specification.new{|s| s.name = 'not-a-plugin' }]
      end

      it "should return the genomer plugin" do
        described_class.plugins.should == [gems.first]
      end

    end

  end

  describe "#to_class_name" do

    it "should dash separated words to camel case" do
      described_class.to_class_name('words-with-dashes').should == "WordsWithDashes"
    end

  end

end
