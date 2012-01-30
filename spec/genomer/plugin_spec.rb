require 'spec_helper'

describe Genomer::Plugin do

  describe "#[]" do

    before do
      mock(described_class).plugins do
        [Gem::Specification.new do |s|
          s.name = 'genomer-plugin-simple'
        end]
      end
    end

    describe "fetching an available plugin" do

      before do
        mock(described_class).require('genomer-plugin-simple')
      end

      it "should return the class for this plugin" do
        expected = GenomerPluginSimple = Class.new
        described_class['simple'].should == expected
      end

    end

    describe "fethcing an unavailble plugin" do

      it "should print an error message" do
        error =  "Unknown command or plugin 'unknown.'\n"
        error << "run `genomer help` for a list of available commands\n"
        lambda{ described_class['unknown'] }.should raise_error(Genomer::Error,error)
      end

    end

  end

  describe "#plugins" do

    before do
      mock(Bundler).setup do
        mock!.gems{ gems }
      end
    end

    describe "where a single genomer plugin is specified" do

      let(:gems) do
        [Gem::Specification.new do |s|
          s.name = 'genomer-plugin-simple'
        end]
      end

      it "should return the genomer plugin" do
        described_class.plugins.should == gems
      end

    end

    describe "where no gems at all are specified" do

      let(:gems) do
        []
      end

      it "should return an empty array" do
        described_class.plugins.should be_empty
      end

    end

    describe "where one plugin and one non-plugin are specified" do

      let(:gems) do
        [Gem::Specification.new{|s| s.name = 'genomer-plugin-simple' },
         Gem::Specification.new{|s| s.name = 'not-a-plugin' }]
      end

      it "should return the genomer plugin" do
        described_class.plugins.should == [gems.first]
      end

    end

  end

  describe "#to_class_name" do

    it "should dash separated words to camel case" do
      described_class.to_class_name('words-with-dashes').should == "WordsWithDashes"
    end

  end

  describe "#scaffold" do

    let(:entries) do
      [Sequence.new(:name => 'seq1', :sequence => 'ATGC')]
    end

    let (:sequence_file) do
      File.new("assembly/sequence.fna",'w')
    end

    let (:scaffold_file) do
      File.new("assembly/scaffold.yml",'w')
    end

    before do
      Dir.mkdir('assembly')
      write_sequence_file(entries,sequence_file)
      write_scaffold_file(entries,scaffold_file)
    end

    after do
      FileUtils.rm_rf 'assembly'
    end

    subject do
      described_class.new(nil,nil)
    end

    it "should return the expected scaffold built from the scaffold files" do
      subject.scaffold.length.should == 1
    end

  end

  describe "#annotations" do

    before do
      Dir.mkdir('assembly')
      write_sequence_file(entries, File.new("assembly/sequence.fna",'w'))
      write_scaffold_file(entries, File.new("assembly/scaffold.yml",'w'))
      generate_gff3_file(records,  File.new("assembly/annotations.gff",'w'))
    end

    after do
      FileUtils.rm_rf 'assembly'
    end

    let(:entries) do
      [Sequence.new(:name => 'seq1', :sequence => 'ATGCATGCATGC')]
    end

    let(:annotation) do
      Annotation.new(
        :seqname    => 'seq1',
        :start      => 1,
        :end        => 3,
        :feature    => 'gene',
        :attributes => {'ID' => 'gene1'})
    end

    let(:options) do
      {}
    end

    subject do
      described_class.new(nil,nil).annotations(options)
    end

    describe "with no annotations" do

      let(:records) do
        []
      end

      it "should return one annotation entry" do
        subject.length.should == 0
      end

    end

    describe "with one annotation" do

      let(:records) do
        [annotation]
      end

      it "should return no annotations" do
        subject.length.should == 1
      end

    end

    describe "with one contig annotation and one non-contig annotation" do

      let(:records) do
        [annotation,annotation.clone.seqname('seq2')]
      end

      it "should return only the contig annotation" do
        subject.length.should == 1
      end

    end

    describe "with multiple unordered annotations" do

      let(:records) do
        [
          annotation.clone.start(4).end(6),
          annotation.clone.start(7).end(9),
          annotation
        ]
      end

      it "should return the annotations in order" do
        subject[0].start.should == 1
        subject[1].start.should == 4
        subject[2].start.should == 7
      end

    end

    describe "with the prefix option" do

      let(:records) do
        [annotation]
      end

      let(:options) do
        {:prefix => 'pre_'}
      end

      it "should prefix the annotation id" do
        subject.first.id.should == 'pre_gene1'
      end

    end

  end

  describe "#initialize" do

    subject do
      described_class.new(:arguments,:flags)
    end

    it "should set the #arguments attribute" do
      subject.arguments.should == :arguments
    end

    it "should set the #flags attribute" do
      subject.arguments.should == :arguments
    end

  end

end
