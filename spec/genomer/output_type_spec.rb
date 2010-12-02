require File.join(File.dirname(__FILE__),'..','spec_helper')

describe Genomer::OutputType do

  it "should have have a method to fetch OutputType subclasses" do
      Genomer::OutputType::Type = Class.new
      Genomer::OutputType['type'].should == Genomer::OutputType::Type
      Genomer::OutputType[:type].should == Genomer::OutputType::Type
  end

end
