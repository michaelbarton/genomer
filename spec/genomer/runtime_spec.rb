require 'spec_helper'

describe Genomer::Runtime do
  include FakeFS::SpecHelpers

  describe "init command" do

    subject do
      Genomer::Runtime.new MockSettings.new(%w|init project_name|)
    end

    after do
      FileUtils.rm_rf('project_name') if File.exists?('project_name')
    end

    describe "with project name argument" do

      before do
        subject.execute!
      end

      it "should create a directory from the named argument" do
        File.exists?('project_name').should be_true
      end

      it "should create a '.gnmr' directory" do
        File.exists?(File.join('project_name','.gnmr')).should be_true
      end

    end

    describe "when project already exists" do

      before do
        Dir.mkdir('project_name')
      end

      it "should raise an error" do
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
        run `genomer help` for a list of available commands
      EOF

      subject.execute!.should == msg.unindent
    end

  end

  describe "help command" do

    subject do
      Genomer::Runtime.new MockSettings.new(%w|help|)
    end

    describe "with no plugins" do

      it "should print the help description" do
        msg = <<-EOF
          genomer COMMAND [options]

          Available commands:
            init        Create a new genomer project
        EOF

        subject.execute!.should == msg.unindent.strip
      end

    end

    describe "with available genomer plugins" do

      before do
        mock(subject).plugins do
          [Gem::Specification.new do |s|
            s.name        = 'genomer-plugin-fake'
            s.summary     = 'A fake scaffolder command'
          end]
        end
      end

      it "should print the help description" do
        msg = <<-EOF
          genomer COMMAND [options]

          Available commands:
            init        Create a new genomer project
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

      it "should print the help description without plugins" do
        msg = <<-EOF
          genomer COMMAND [options]

          Available commands:
            init        Create a new genomer project
        EOF
        subject.execute!.should == msg.unindent.strip
      end

    end

  end

  describe "unknown command" do

    subject do
      Genomer::Runtime.new MockSettings.new(%w|unknown|)
    end

    it "should print an error message" do
      error =  "Unknown command or plugin 'unknown.'\n"
      error << "run `genomer help` for a list of available commands\n"
      lambda{ subject.execute! }.should raise_error(GenomerError,error)
    end

  end

  describe "using plugins on the command line" do

    subject do
      Genomer::Runtime.new(MockSettings.new(%w|fake|))
    end

    before do
      mock(subject).plugins do
        [Gem::Specification.new do |s|
          s.name        = 'genomer-plugin-fake'
        end]
      end
    end

    let(:plugin) do
      require 'genomer-plugin-fake'
      GenomerPluginFake.new(nil)
    end

    it "should return the expected result of calling the gem" do
      subject.execute!.should == plugin.run
    end

  end

  describe "#plugins" do

    after do
      FileUtils.rm('Gemfile') if File.exists?('Gemfile')
    end

    before do
      FileUtils.touch 'Gemfile'
    end

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

    subject do
      Genomer::Runtime.new(MockSettings.new(%w|help|)).plugins
    end

    describe "where a single genomer plugins is specified" do

      before do
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
        bundle = Object.new
        mock(bundle).gems{ [plugin, not_a_plugin] }
        mock(Bundler).setup{ bundle }
      end

      it "should return the genomer plugin" do
        subject.should == [plugin]
      end

    end

  end

  describe "#to_class_name" do

    subject do
      Genomer::Runtime.new MockSettings.new
    end

    it "should dash separated words to camel case" do
      subject.to_class_name('words-with-dashes').should == "WordsWithDashes"
    end

  end

end
