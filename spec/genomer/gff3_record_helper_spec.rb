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

  describe "#reverse" do

    subject do
      Annotation.new(:start => 1,:end => 3).to_gff3_record.reverse
    end

    it "should reverse the start coordinate" do
      subject.start.should == 3
    end

    it "should reverse the stop coordinate" do
      subject.end.should == 1
    end

  end

end
