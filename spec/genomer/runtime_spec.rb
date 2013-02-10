require 'spec_helper'

describe Genomer::Runtime do

  subject do
    Genomer::Runtime.new MockSettings.new arguments, flags
  end

  let(:flags){ {} }
  let(:arguments){ [] }

  describe "run" do

    context "inside a genomer project" do

      before do
        stub.instance_of(described_class).genomer_project?{ true }
      end

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

        describe "passed the init command" do

          after do
            FileUtils.rm_rf('project_name') if File.exists?('project_name')
          end

          let(:arguments){ %w|init project_name| }

          it "should raise a genomer error" do
            lambda{ subject.execute! }.
              should raise_error(Genomer::Error,"This directory contains a 'Gemfile' and already appears to be a genomer project.")
          end

        end
      end

    context "outside a genomer project" do

      before do
        stub.instance_of(described_class).genomer_project?{ false }
      end

      describe "passed no arguments" do

        it "should print the short help description" do
          msg = <<-EOF
          Use `genomer init NAME` to create a new genomer project called NAME
          EOF
          subject.execute!.should == msg.unindent
        end

      end

      describe "passed the init command with a project name argument" do

        let(:arguments){ %w|init project_name| }

        after do
          FileUtils.rm_rf('project_name') if File.exists?('project_name')
        end

        before do
          @msg = subject.execute!
        end

        it "should print message that project has been created" do
          @msg.should == "Genomer project 'project_name' created.\n"
        end

        it "should create the expected directories" do
          File.exists?('project_name').should be_true
          File.exists?(File.join('project_name','assembly')).should be_true
        end

        it "should create a 'scaffold.yml' file" do
          file = File.join('project_name','assembly','scaffold.yml')
          File.exists?(file).should be_true
          File.read(file).should == <<-EOF.unindent
            # Specify your genome scaffold in YAML format here. Reference nucleotide
            # sequences in the 'sequences.fna' file using the first space delimited
            # word of each fasta header.
            #
            # Go to http://next.gs/getting-started/ to start writing genome scaffold
            # files.
            #
            # A simple one contig example is also provided below. Delete this as you
            # start writing your own scaffold.
            ---
              -
                sequence:
                  source: "contig1"
          EOF
        end

        it "should create a 'sequence.fna' file" do
          file = File.join('project_name','assembly','sequence.fna')
          File.exists?(file).should be_true
          File.read(file).should == <<-EOF.unindent
            ; Add your assembled contigs and scaffolds sequences to this file.
            ; These sequences can be referenced in the 'scaffold.yml' file
            ; using the first space delimited word in each fasta header.
            > contig1
            ATGC
          EOF
        end

        it "should create a 'annotations.gff' file" do
          file = File.join('project_name','assembly','annotations.gff')

          File.exists?(file).should be_true
          File.read(file).should == <<-EOF.unindent
            ##gff-version   3
            ## Add your gff3 formatted annotations to this file
          EOF
        end

        it "should create a 'Gemfile' file" do
          file    = File.join('project_name','Gemfile')
          version = Genomer::VERSION.split('.')[0..1] << '0'


          File.exists?(file).should be_true
          File.read(file).should == <<-EOF.unindent
            source :rubygems

            gem 'genomer',    '~> #{version.join('.')}'
          EOF
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
