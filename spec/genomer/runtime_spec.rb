require 'spec_helper'

describe Genomer::Runtime do
  include FakeFS::SpecHelpers

  describe "command" do

    describe "none" do

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

    describe "unknown" do

      subject do
        Genomer::Runtime.new MockSettings.new(%w|unknown|)
      end

      it "should print an error message" do
        error =  "Unknown command or plugin 'unknown.'\n"
        error << "run `genomer help` for a list of available commands\n"
        lambda{ subject.execute! }.should raise_error(GenomerError,error)
      end

    end

    describe "init" do

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

        it "should create an 'assembly' directory" do
          File.exists?(File.join('project_name','assembly')).should be_true
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

    describe "help" do

      subject do
        Genomer::Runtime.new MockSettings.new(%w|help|)
      end

      before do
        mock(Genomer::Plugin).plugins{ gems }
      end

      describe "with no available plugins" do

        let (:gems) do
          []
        end

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

        let (:gems) do
          [Gem::Specification.new do |s|
            s.name        = 'genomer-plugin-simple'
            s.summary     = 'A simple scaffolder command'
          end]
        end

        it "should print the help description" do
          msg = <<-EOF
            genomer COMMAND [options]

            Available commands:
              init        Create a new genomer project
              simple      A simple scaffolder command
          EOF
          subject.execute!.should == msg.unindent.strip
        end

      end

    end

  end

  describe "#initialize" do

    subject do
      Genomer::Runtime.new settings
    end

    describe "with arguments and flags" do

      let(:settings) do
        MockSettings.new(%w|init project_name|, {:flag => 'something'})
      end

      it "should set the runtime variables" do
        subject.command.should == 'init'
        subject.arguments.should == ['project_name']
        subject.flags[:flag] == settings.flags[:flag]
      end

    end

  end

  describe "#run_plugin" do

    before do
      mock(Genomer::Plugin).[]('plugin') do
         mock!.new(anything,anything) do
           mock!.run
         end
      end
    end

    subject do
      Genomer::Runtime.new MockSettings.new(%w|plugin arg1 arg2|, {:flag => 'arg3'})
    end

    it "should fetch, initialize and run the required plugin" do
      subject.run_plugin
    end

  end
end
