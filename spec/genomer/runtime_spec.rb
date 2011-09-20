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
        FileUtils.rm_rf('project_name') if File.exists?('project_name')
      end

      it "should create a directory from the named argument" do
        File.exists?('project_name').should be_true
      end

      it "should create a '.gnmr' directory" do
        File.exists?(File.join('project_name','.gnmr')).should be_true
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

  describe "no command" do

    subject do
      Genomer::Runtime.new MockSettings.new
    end

    it "should print the short help description" do
      msg = <<-EOF
        genomer COMMAND [options]
        run `genomer help` for a list of available commands`
      EOF

      subject.execute!.should == msg.unindent
    end

  end

  describe "help command" do

    subject do
      Genomer::Runtime.new MockSettings.new(%w|help|)
    end

    it "should print the help description" do
      msg = <<-EOF
        genomer COMMAND [options]

        Available commands:
      EOF

      subject.execute!.split("\n")[0..2].join("\n").should == msg.unindent.strip
    end

  end

end

