require 'spec/spec_helper'

describe "the genomer binary" do

  before(:each) do
    @empty_rules = Tempfile.new('genomer').path
    @genomer = File.join %W| #{File.dirname(__FILE__)} .. bin genomer|
  end

  it "should exist" do
    File.exists?(@genomer).should be_true
  end

  it "should be executable" do
    File.executable?(@genomer).should be_true
  end

  it "should return a 0 exit when run with an empty Rules file" do
    clean = system(@genomer,Tempfile.new('genomer').path)
    clean.should be_true
    $?.should == 0
  end

end
