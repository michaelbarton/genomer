require File.join(File.dirname(__FILE__),'..','spec_helper')

describe Genomer::OutputType do

  it "should have have a method to fetch OutputType subclasses" do
    Genomer::OutputType::Type = Class.new
    Genomer::OutputType['type'].should == Genomer::OutputType::Type
    Genomer::OutputType[:type].should == Genomer::OutputType::Type
  end

  describe "output file method" do

    before(:each) do
      @rules = Genomer::RulesDSL.new
      @rules.out_file_name 'genome'
      @suffix = 'suffix'
      Genomer::OutputType.const_set("SUFFIX", @suffix)
    end

    it "should create output file name using output name and suffix" do
      out = Genomer::OutputType.new(@rules)
      out.file.should == @rules.out_file_name + '.' + @suffix
    end

    it "should use output directory if specified" do
      @rules.out_dir_name 'dir'
      expected = File.join('dir', @rules.out_file_name + '.' + @suffix)
      Genomer::OutputType.new(@rules).file.should == expected
    end

    it "should use the suffix constant of the subclass" do
      sub = Class.new(Genomer::OutputType)
      sub.const_set("SUFFIX",'new_suffix')
      out = sub.new(@rules)
      out.file.should == @rules.out_file_name + '.' + 'new_suffix'
    end

    after(:each) do
      Genomer::OutputType.send(:remove_const,"SUFFIX")
    end

  end

end
