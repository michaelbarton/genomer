require 'spec_helper'

describe Genomer::Runtime do

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

  end

end
