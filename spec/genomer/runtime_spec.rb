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

    describe "with no plugins" do

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

    describe "with avaiable genomer plugins" do

      before do
        mock(subject).plugins do
          [Gem::Specification.new do |s|
            s.name        = 'genomer-plugin-fake'
            s.description = 'A fake scaffolder command'
          end]
        end
      end

      subject do
        Genomer::Runtime.new MockSettings.new(%w|help|)
      end

      it "should print the help description" do
        msg = <<-EOF
          genomer COMMAND [options]

          Available commands:
            fake        A fake scaffolder command
        EOF

        subject.execute!.should == msg.unindent.strip
      end

    end

    describe "with non-genomer plugins in the Gemfile" do

      before do
        mock(subject).plugins do
          []
        end
      end

      subject do
        Genomer::Runtime.new MockSettings.new(%w|help|)
      end

      it "should print the help description without plugins" do
        msg = <<-EOF
          genomer COMMAND [options]

          Available commands:
        EOF
        subject.execute!.should == msg.unindent.strip
      end

    end

  end

  describe "#plugins" do

    let(:plugin) do
      Gem::Specification.new do |s|
        s.name = 'genomer-plugin-fake'
      end
    end

    let(:not_a_plugin) do
      Gem::Specification.new do |s|
        s.name = 'rr'
      end
    end

    after do
      FileUtils.rm('Gemfile') if File.exists?('Gemfile')
    end

    subject do
      Genomer::Runtime.new(MockSettings.new(%w|help|)).plugins
    end

    describe "where a single genomer plugins is specified" do

      before do
        FileUtils.touch 'Gemfile'

        # Mock Bundler behavior
        bundle = Object.new
        mock(bundle).gems{ [plugin] }
        mock(Bundler).setup{ bundle }
      end

      it "should return the genomer plugin" do
        subject.should == [plugin]
      end

    end

    describe "where no genomer plugins are specified" do

      before do
        FileUtils.touch 'Gemfile'

        # Mock Bundler behavior
        bundle = Object.new
        mock(bundle).gems{ [not_a_plugin] }
        mock(Bundler).setup{ bundle }
      end

      it "should return an empty array" do
        subject.should be_empty
      end

    end

    describe "where one plugins and non plugin are specified" do

      before do
        FileUtils.touch 'Gemfile'

        # Mock Bundler behavior
        bundle = Object.new
        mock(bundle).gems{ [plugin, not_a_plugin] }
        mock(Bundler).setup{ bundle }
      end

      it "should return the genomer plugin" do
        subject.should == [plugin]
      end

    end

  end

end

