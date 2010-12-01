require File.join(File.dirname(__FILE__),'..','spec_helper')

describe Genomer::RulesDSL do

  before(:each) do
    @dsl = Genomer::RulesDSL.new
  end

  describe "file location attributes" do

    it "should include scaffold_file" do
      @dsl.scaffold_file "location"
      @dsl.scaffold_file.should == "location"
    end

    it "should include sequence_file" do
      @dsl.sequence_file "location"
      @dsl.sequence_file.should == "location"
    end

  end

  describe "output types method" do

    it "should allow single output types to be set" do
      @dsl.output :type
      @dsl.output.should == [:type]
    end

    it "should allow multipe output types to be set" do
      @dsl.output :type1, :type2
      @dsl.output.should == [:type1, :type2]
    end

    it "should allow incremental addition of types" do
      @dsl.output :type1
      @dsl.output :type2
      @dsl.output.should == [:type1, :type2]
    end

  end

end
