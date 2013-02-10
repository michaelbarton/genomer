require 'spec_helper'

describe Genomer::Runtime do
  include FakeFS::SpecHelpers

  subject do
    Genomer::Runtime.new MockSettings.new arguments, flags
  end

  let(:flags){ {} }
  let(:arguments){ [] }

  describe "run" do

    context "with a Gemfile preset" do

      describe "passed no arguments" do

        it "should print the short help description" do
          msg = <<-EOF
          genomer COMMAND [options]
          run `genomer help` for a list of available commands
          EOF
          subject.execute!.should == msg.unindent
        end

      end

      describe "passed the --version flag" do

        let(:flags) do
          {:version => true}
        end

        it "should print the version information" do
          msg = "Genomer version #{Genomer::VERSION}"
          subject.execute!.should == msg.unindent
        end

      end

      describe "passed an unknown command" do

        let(:arguments){ %w|unknown| }

        it "should print an error message" do
          error = <<-EOF
          Unknown command or plugin 'unknown.'
          run `genomer help` for a list of available commands
          EOF
          lambda{ subject.execute! }.should raise_error(Genomer::Error,error.unindent)
        end

      end

      describe "passed help command with no available plugins" do

        let(:arguments){ %w|help| }

        before do
          mock(Genomer::Plugin).plugins{ gems }
          mock(File).exists?('Gemfile'){ true }
        end

        let(:gems) do
          []
        end

        it "should print the header description" do
          msg = <<-EOF
            genomer COMMAND [options]

            Available commands:
          EOF
          subject.execute!.should include msg.unindent.strip
        end

        it "should show the init command" do
          subject.execute!.should include "init        Create a new genomer project"
        end

        it "should show the man command" do
          subject.execute!.should include "man         View man page for the specified plugin"
        end
        end

      describe "passed help command with one available plugin" do

        let(:arguments){ %w|help| }

        before do
          mock(Genomer::Plugin).plugins{ gems }
          mock(File).exists?('Gemfile'){ true }
        end

        let(:gems) do
          [Gem::Specification.new do |s|
            s.name        = 'genomer-plugin-simple'
            s.summary     = 'A simple scaffolder command'
          end]
        end

        it "should print the plugin command description" do
          subject.execute!.should include "simple      A simple scaffolder command"
        end

      end

      describe "passed the man command with no arguments" do

        let(:arguments){ %w|man| }

        it "should print the man help description" do
          msg = <<-EOF
            genomer man COMMAND
            run `genomer help` for a list of available commands
          EOF
          subject.execute!.should include msg.unindent.strip
        end

        end

      describe "passed the man command with an argument" do

        let(:arguments){ %w|man simple| }
        let(:man_file){ 'a' }
        let(:groffed_man_file){ mock!.path{ 'b' } }

        before do
          mock(subject).man_file(['simple']){ man_file }
          mock(subject).groffed_man_file(man_file){ groffed_man_file }
          mock(File).exists?(man_file){true}
        end

        it "should call man for the groffed path" do
          mock(Kernel).exec("man b")
          subject.execute!
        end

      end

      describe "passed the man command with the argument 'init'" do

        let(:arguments){ %w|man init| }
        let(:man_file){ File.expand_path File.dirname(__FILE__) + '/../../man/genomer-init.1.ronn' }
        let(:groffed_man_file){ mock!.path{ 'b' } }

        before do
          dont_allow(subject).man_file
          mock(subject).groffed_man_file(man_file){ groffed_man_file }
          mock(File).exists?(man_file){true}
        end

        it "should call man for the groffed path" do
          mock(Kernel).exec("man b")
          subject.execute!
        end

      end

      describe "passed the man command for a plugin" do

        let(:arguments){ %w|man simple subcommand| }
        let(:man_file){ 'a' }
        let(:groffed_man_file){ mock!.path{ 'b' } }

        before do
          mock(subject).man_file(['simple','subcommand']){ man_file }
          mock(subject).groffed_man_file(man_file){ groffed_man_file }
          mock(File).exists?(man_file){true}
        end

        it "should call man for the groffed path" do
          mock(Kernel).exec("man b")
          subject.execute!
        end

      end

        describe "passed the man command with an unknown plugin argument" do

          let(:arguments){ %w|man simple subcommand| }
          let(:man_file){ 'a' }

          before do
            mock(subject).man_file(['simple','subcommand']){ man_file }
            mock(File).exists?(man_file){false}
          end

          it "should raise a genomer error" do
            lambda{ subject.execute! }.
              should raise_error(Genomer::Error,"No manual entry for command 'simple subcommand'")
          end

        end

      end

  end

  describe "#initialize" do

    describe "with arguments and flags" do

      let(:arguments){ %w|init project_name| }
      let(:flags){ {:flag => 'something'} }

      it "should set the runtime variables" do
        subject.command.should   == 'init'
        subject.arguments.should == ['project_name']
        subject.flags[:flag]     == flags[:flag]
      end

    end

  end

  describe "#man_file" do

    before do
      mock(Genomer::Plugin).fetch('simple') do
        mock!.full_gem_path{ '/tmp' }
      end
    end

    it "should return the path to the man page for a command" do
      subject.man_file(['simple']).should == '/tmp/man/genomer-simple.ronn'
    end

    it "should return the path to the man page for a subcommand" do
      subject.man_file(['simple','subcommand']).should == '/tmp/man/genomer-simple-subcommand.ronn'
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

    let(:arguments){ %w|plugin arg1 arg2| }
    let(:flags){ {:flag => 'arg3'} }

    it "should fetch, initialize and run the required plugin" do
      subject.run_plugin
    end

  end

end
