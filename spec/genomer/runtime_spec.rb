require File.join(File.dirname(__FILE__),'..','spec_helper')

describe Genomer::Runtime do
  include FakeFS::SpecHelpers

  before(:each) do
    @runtime = Genomer::Runtime.new
    @rules   = File.new('Rules','w').path
  end

  describe "when configured on an empty rules file" do
    it "should return a RulesDSL instance" do
      @runtime.configure(@rules).should be_instance_of(Genomer::RulesDSL)
    end
  end

  describe "when configured on a filled rules file" do

    before(:each) do
      @text = {:scaffold_file => 'scaf', :sequence_file => 'seq',
        :output => 'output'}

      File.open(@rules,'w') do |out|
        @text.each{|method,value| out.puts("#{method} '#{value}'") }
      end

     @dsl = @runtime.configure(@rules)
    end

    it "should return a RulesDSL instance" do
      @dsl.should be_instance_of(Genomer::RulesDSL)
    end

    it "should set the scaffold_file location" do
      @dsl.scaffold_file.should == @text[:scaffold_file]
    end

    it "should set the scaffold_file location" do
      @dsl.sequence_file.should == @text[:sequence_file]
    end

    it "should set the output types" do
      @dsl.output.first.should == @text[:output]
    end

  end

end
