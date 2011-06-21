require 'spec/spec_helper'

describe Genomer::OutputType do

  it "should have have a method to fetch OutputType subclasses" do
    Genomer::OutputType::Type = Class.new
    Genomer::OutputType['type'].should == Genomer::OutputType::Type
    Genomer::OutputType[:type].should == Genomer::OutputType::Type
  end

  describe "#file" do

    before(:each) do
      @rules = Genomer::RulesDSL.new
      @rules.out_file_name 'genome'
      @suffix = 'suffix'
      Genomer::OutputType.const_set("SUFFIX", @suffix)
    end

    it "should create output file name using output name and suffix" do
      out = Genomer::OutputType.new(@rules)
      out.file.should == @rules.out_file_name + '.' + @suffix
    end

    it "should use output directory if specified" do
      @rules.out_dir_name 'dir'
      expected = File.join('dir', @rules.out_file_name + '.' + @suffix)
      Genomer::OutputType.new(@rules).file.should == expected
    end

    it "should use the suffix constant of the subclass" do
      sub = Class.new(Genomer::OutputType)
      sub.const_set("SUFFIX",'new_suffix')
      out = sub.new(@rules)
      out.file.should == @rules.out_file_name + '.' + 'new_suffix'
    end

    after(:each) do
      Genomer::OutputType.send(:remove_const,"SUFFIX")
    end

  end

  describe "#sequence" do
    subject do
      rules = generate_rules [Sequence.new(:name => 'seq1', :sequence => 'ATGC')]
      Genomer::OutputType.new(rules)
    end
    its(:sequence){should == 'ATGC' }
  end

  describe "#annotations" do

    subject{ Genomer::OutputType.new(rules) }

    before do
      @annotation = Annotation.new(:seqname => 'seq1')
    end

    let(:rules) do
      generate_rules(
        [Sequence.new(:name => 'seq1', :sequence => 'ATG' * 4)],
        annotations)
    end

    context "when there is no annotations file set" do

      let(:rules) do
        rules = generate_rules [Sequence.new(:name => 'seq1', :sequence => 'ATGC')]
        rules.annotation_file nil
        rules
      end

      its(:annotations){should == [] }

      it "should cache the annotations array" do
        subject.annotations.should equal(subject.annotations)
      end
    end

    context "when the annotations file is empty" do

      let(:rules) do
        rules = generate_rules [Sequence.new(:name => 'seq1', :sequence => 'ATGC')]
        rules
      end

      its(:annotations){should == [] }

      it "should cache the annotations array" do
        subject.annotations.should equal(subject.annotations)
      end

    end

    context "when the annotations file contains an annotation" do

      let(:annotations) do
        [@annotation]
      end

      its(:annotations){should_not be_empty }

      it "should cache the annotations array" do
        subject.annotations.should equal(subject.annotations)
      end

    end

    context "sorting by start position" do

      let(:annotations) do
        [@annotation.clone.start(2),@annotation]
      end

      its(:annotations){should_not be_empty }

      it "should cache the annotations array" do
        subject.annotations.should equal(subject.annotations)
      end

      it "return the sorted array of annotations" do
        subject.annotations.first.start.should == 1
        subject.annotations.last.start.should == 2
      end

    end

    context "sorting by start position" do

      let(:annotations) do
        [@annotation.clone.end(3),@annotation.end(2)]
      end

      its(:annotations){should_not be_empty }

      it "should cache the annotations array" do
        subject.annotations.should equal(subject.annotations)
      end

      it "return the sorted array of annotations" do
        subject.annotations.first.end.should == 2
        subject.annotations.last.end.should == 3
      end

    end

  end

  describe "#identifier" do

    subject{ Genomer::OutputType.new(rules) }

    context "when there is no identifier set" do

      let(:rules) do
        rules = generate_rules [Sequence.new(:name => 'seq1', :sequence => 'ATGC')]
        rules.identifier nil
        rules
      end

      its(:identifier){should be_nil }

    end

    context "when the is identifier is set" do

      let(:rules) do
        rules = generate_rules [Sequence.new(:name => 'seq1', :sequence => 'ATGC')]
        rules.identifier 'something'
        rules
      end

      its(:identifier){should == 'something' }

    end

  end

end
