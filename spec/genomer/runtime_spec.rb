require 'spec_helper'

describe Genomer::Runtime do
  include FakeFS::SpecHelpers

  before(:each) do
    @rules = File.new('Rules','w').path
  end

  describe "when initialized" do

    it "should return a RulesDSL instance for an empty Rules file" do
      runtime = Genomer::Runtime.new(@rules)
      runtime.rules.should be_instance_of(Genomer::RulesDSL)
    end

    it "should call the required methods for a filled Rules file" do
      @methods = {:m1 => 'v1', :m2 => 'v2'}

      @methods.each do |method,value|
        File.open(@rules,'a'){|out| out.puts("#{method} '#{value}'")}
        Genomer::RulesDSL.any_instance.expects(method).with(value)
      end

      runtime = Genomer::Runtime.new(@rules)
      runtime.rules.should be_instance_of(Genomer::RulesDSL)
    end

  end

  describe "when executed" do

    it "should call the required output generator with the dsl instance" do
      rules = Genomer::RulesDSL.new
      rules.output :outputter

      mock_instance = mock
      mock_instance.expects(:file).returns('fake_file')
      mock_instance.expects(:generate)

      mock_class    = mock
      mock_class.expects(:new).with(rules).returns(mock_instance)
      Genomer::OutputType.expects(:[]).with(:outputter).returns(mock_class)

      run = Genomer::Runtime.new(@rules)
      run.rules = rules
      run.execute!
    end

  end

end
