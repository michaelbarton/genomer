require 'spec_helper'

describe Genomer::Runtime do
  include FakeFS::SpecHelpers

  describe "init command" do

    describe "with project name argument" do

      subject do
        Genomer::Runtime.new MockSettings.new(%w|init project_name|)
      end

      before do
        subject.execute!
      end

      after do
        Dir.rmdir('project_name') if File.exists?('project_name')
      end

      it "should create a directory from the named argument" do
        File.exists?('project_name').should be_true
      end

    end

    describe "when project already exists" do

      subject do
        Genomer::Runtime.new MockSettings.new(%w|init project_name|)
      end

      before do
        Dir.mkdir('project_name')
      end

      after do
        Dir.rmdir('project_name')
      end

      it "should create a directory from the named argument" do
        lambda{ subject.execute! }.should raise_error(GenomerError,
          "Directory 'project_name' already exists.")
      end

    end

  end

end
