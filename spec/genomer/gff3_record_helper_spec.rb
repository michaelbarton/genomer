require 'spec/spec_helper'

describe Genomer::GffRecordHelper do

  describe "module" do
    it "should be included in Bio::GFF::GFF3::Record" do
      Bio::GFF::GFF3::Record.ancestors.should include(described_class)
    end
  end

  describe "#negative_strand?" do

    subject do
      Annotation.new
    end

    it "should return false for a positive strand annotation" do
      subject.strand('+').to_gff3_record.
        negative_strand?.should be_false
    end

    it "should return true for a negative strand annotation" do
      subject.strand('-').to_gff3_record.
        negative_strand?.should be_true
    end

  end

  describe "#to_feature_table" do

    before(:each) do
      @attn = Annotation.new(:start  => 1, :end => 3,
                             :strand => '+')
    end

    subject do
      annotation.to_gff3_record.to_genbank_feature_row
    end

    context "gene feature on the positive strand" do

      let(:annotation) do
        @attn.feature('gene')
      end

      it "should return a table array" do
        subject.should == [[1,3,'gene']]
      end

    end

    context "gene feature on the negative strand" do

      let(:annotation) do
        @attn.strand('-').feature('gene')
      end

      it "should return a table array" do
        subject.should == [[3,1,'gene']]
      end

    end

    context "gene feature with attributes" do

      let(:annotation) do
        @attn.feature('gene').attributes('one' => 'two')
      end

      it "should return a table array" do
        subject.should == [[1,3,'gene'],['one','two']]
      end

    end

    context "gene feature with ID attributes" do

      let(:annotation) do
        @attn.feature('gene').attributes('ID' => 'two')
      end

      it "should return a table array" do
        subject.should == [[1,3,'gene'],['locus_tag','two']]
      end

    end

  end

end
