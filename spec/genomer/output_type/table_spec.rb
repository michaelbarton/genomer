require 'spec/spec_helper'

describe Genomer::OutputType::Table do

  before do
    @annotation = Annotation.new(:seqname => 'seq1',
                                 :start => 1, :end => 3,:feature => 'CDS')
  end

  describe "class contants" do
    it{ described_class.should define_the_suffix_constant_as('tbl') }
    it{ described_class.should subclass_genomer_output_type }
  end

  describe "#generate" do

    subject do
      described_class.new(generate_rules(sequences,annotations,metadata)).generate
    end


    let(:sequences){ [Sequence.new(:name => 'seq1', :sequence => 'ATGATGATGATG')] }
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
        {:identifier => 'something', :map_annotations => {'something' => 'other'}}
      end

      let(:annotations) do
        [@annotation.clone.attributes({'something' => 'gene1'})]
      end

      it "should generate the expected annotation table" do
        subject.should == <<-EOS.unindent
          >Feature\tsomething\tannotation_table
          1\t3\tCDS
          \t\t\tother\tgene1
        EOS
      end

    end

    context "with a single annotation with the annotation id field specified" do

      let(:metadata) do
        {:identifier => 'something', :annotation_id_field => 'ID'}
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

    context "with a multiple annotations reseting the gene ID count" do

      let(:metadata) do
        {:identifier => 'something', :annotation_id_field => 'ID',
          :reset_annotation_id_field => true}
      end

      let(:annotations) do
        [
          @annotation.clone.attributes({'ID' => 'gene1'}),
          @annotation.clone.attributes({'ID' => 'gene2'}).start(4).end(6),
          @annotation.clone.attributes({'ID' => 'gene3'}).start(7).end(9),
          @annotation.clone.attributes({'ID' => 'gene4'}).start(10).end(12)
        ]
      end

      it "should generate the expected annotation table" do
        subject.should == <<-EOS.unindent
          >Feature\tsomething\tannotation_table
          1\t3\tCDS
          \t\t\tlocus_tag\t000001
          4\t6\tCDS
          \t\t\tlocus_tag\t000002
          7\t9\tCDS
          \t\t\tlocus_tag\t000003
          10\t12\tCDS
          \t\t\tlocus_tag\t000004
        EOS
      end

    end
  end

  describe "#reset_id" do

    subject do
      described_class.reset_id annotations, 'ID'
    end

    context "passed no annotations" do

      let(:annotations){[]}

      it "should return an empty array" do
        subject.should == []
      end

    end

    context "passed a single annotation" do

      let(:annotations) do
        a = [@annotation.clone.attributes({'ID' => 'gene1'})]
        a.map{|a| a.to_gff3_record}
      end

      it "should return an empty array" do
        subject.first.attributes.should == [['ID','000001']]
      end

    end

  end

end
