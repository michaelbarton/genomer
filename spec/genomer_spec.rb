require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "the genomer binary" do

  before(:each) do
    @empty_rules = Tempfile.new('genomer').path
  end

  it "should exist" do
    File.exists?(GENOMER).should be_true
  end

  it "should be executable" do
    File.executable?(GENOMER).should be_true
  end

  it "should return a 0 exit when run with an empty Rules file" do
    clean = system(GENOMER,Tempfile.new('genomer').path)
    clean.should be_true
    $?.should == 0
  end

end
