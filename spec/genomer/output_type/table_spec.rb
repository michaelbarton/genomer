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

    before do
      @annotation = Annotation.new(:seqname => 'seq1',
                                   :start => 1, :end => 3,:feature => 'CDS')
    end

    let(:sequences){ [Sequence.new(:name => 'seq1', :sequence => 'ATGATG')] }
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
        [@annotation]
      end

      it "should generate the expected annotation table" do
        subject.should == <<-EOS.unindent
          >Feature\tsomething\tannotation_table
          1\t3\tCDS
        EOS
      end

    end

    context "with a reversed annotation" do

      let(:annotations) do
        [@annotation.clone.strand('-')]
      end

      it "should generate the expected annotation table" do
        subject.should == <<-EOS.unindent
          >Feature\tsomething\tannotation_table
          3\t1\tCDS
        EOS
      end

    end

    context "with an annotation with attributes" do

      let(:annotations) do
        [@annotation.clone.attributes({'ID' => 'gene1'})]
      end

      it "should generate the expected annotation table" do
        subject.should == <<-EOS.unindent
          >Feature\tsomething\tannotation_table
          1\t3\tCDS
          \t\t\tID\tgene1
        EOS
      end

    end

    context "with two annotations" do

      let(:annotations) do
        [@annotation,@annotation.clone.start(4).end(6)]
      end

      it "should generate the expected annotation table" do
        subject.should == <<-EOS.unindent
          >Feature\tsomething\tannotation_table
          1\t3\tCDS
          4\t6\tCDS
        EOS
      end

    end

    context "with a single annotation with the ID field mapped to locus_tag" do

      let(:metadata) do
        {:identifier => 'something', :map_annotations => {'ID' => 'locus_tag'}}
      end

      let(:annotations) do
        [@annotation.clone.attributes({'ID' => 'gene1'})]
      end

      it "should generate the expected annotation table" do
        subject.should == <<-EOS.unindent
          >Feature\tsomething\tannotation_table
          1\t3\tCDS
          \t\t\tlocus_tag\tgene1
        EOS
      end

    end
  end

end
