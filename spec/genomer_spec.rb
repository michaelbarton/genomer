require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "the genomer binary" do

  it "should exist" do
    File.exists?(GENOMER).should be_true
  end

  it "should be executable" do
    File.executable?(GENOMER).should be_true
  end

  it "should return a 0 exit when run without arguments" do
    clean = system GENOMER
    clean.should be_true
    $?.should == 0
  end

end
