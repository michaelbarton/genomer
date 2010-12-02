require File.join(File.dirname(__FILE__),'..','spec_helper')

describe Genomer::Runtime do
  include FakeFS::SpecHelpers

  before(:each) do
    @runtime = Genomer::Runtime.new
    @rules   = File.new('Rules','w').path
  end

  describe "when configured" do

    it "should return a RulesDSL instance for an empty Rules file" do
      @runtime.configure(@rules).should be_instance_of(Genomer::RulesDSL)
    end

    it "should call the required methods for a filled Rules file" do
      @methods = {:m1 => 'v1', :m2 => 'v2'}

      @methods.each do |method,value|
        File.open(@rules,'a'){|out| out.puts("#{method} '#{value}'")}
        Genomer::RulesDSL.any_instance.expects(method).with(value)
      end

      @dsl = @runtime.configure(@rules)
      @dsl.should be_instance_of(Genomer::RulesDSL)
    end

  end

end
