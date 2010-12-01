require File.join(File.dirname(__FILE__),'..','spec_helper')

describe Genomer::RulesDSL do

  before(:each) do
    @dsl = Genomer::RulesDSL.new
  end

  describe "methods" do

    it "should include scaffold_file attribute" do
      @dsl.scaffold_file "location"
      @dsl.scaffold_file.should == "location"
    end

    it "should include sequence_file attribute" do
      @dsl.sequence_file "location"
      @dsl.sequence_file.should == "location"
    end

  end

end
