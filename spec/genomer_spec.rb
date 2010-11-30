require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "the genomer binary" do

  before do
    @bin = File.join %W| #{File.dirname(__FILE__)} .. bin genomer|
  end

  it "should exist" do
    File.exists?(@bin).should be_true
  end

  it "should be executable" do
    File.executable?(@bin).should be_true
  end

  it "should return a 0 exit when run without arguments" do
    clean = system @bin
    clean.should be_true
    $?.should == 0
  end

end
