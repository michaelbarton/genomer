require 'spec/spec_helper'

describe Genomer::OutputType::Table do

  describe "class contants" do
    it{ described_class.should define_the_suffix_constant_as('tbl') }
    it{ described_class.should subclass_genomer_output_type }
  end

  describe "#generate" do

    subject do
      described_class.new(generate_rules(sequences,annotations,metadata)).generate
    end

    let(:sequences){ [Sequence.new(:name => 'seq1', :sequence => 'ATG')] }
    let(:metadata){ {:identifier => 'something'} }

    context "using an empty annotation set" do

      let(:annotations) do
        []
      end

      it "should generate an empty annotation table" do
        subject.should == ">Feature\tsomething\tannotation_table\n"
      end

    end

    context "with a single annotation" do

      let(:annotations) do
        [Annotation.new(:seqname => 'seq1',:start => 1, :end => 3,
                        :feature => 'CDS')]
      end

      it "should generate an empty annotation table" do
        subject.should == <<-EOS.unindent
          >Feature\tsomething\tannotation_table
          1\t3\tCDS
        EOS
      end

    end

    context "with a reversed annotation" do

      let(:annotations) do
        [Annotation.new(:seqname => 'seq1',:start   => 1, :end => 3,
                        :strand  => '-',   :feature => 'CDS')]
      end

      it "should generate an empty annotation table" do
        subject.should == <<-EOS.unindent
          >Feature\tsomething\tannotation_table
          3\t1\tCDS
        EOS
      end

    end

  end

end
