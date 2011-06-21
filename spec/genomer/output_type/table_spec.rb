require 'spec/spec_helper'

describe Genomer::OutputType::Table do

  before do
    @annotation = Annotation.new(:seqname => 'seq1',
                                 :start => 1, :end => 3,:feature => 'gene')
  end

  describe "class contants" do
    it{ described_class.should define_the_suffix_constant_as('tbl') }
    it{ described_class.should subclass_genomer_output_type }
  end

  describe "#generate" do

    subject do
      described_class.new(generate_rules(sequences,annotations,metadata)).generate
    end

    let(:sequences) do
      [Sequence.new(:name => 'seq1', :sequence => 'ATGATGATGATG')]
    end

    let(:metadata) do
      {:identifier => 'something'}
    end

    context "with no annotations" do

      let(:annotations) do
        []
      end

      it "should generate an empty annotation table" do
        subject.should == ">Feature\tsomething\tannotation_table\n"
      end

    end

    context "with only gene features: " do

      context "one gene" do

        let(:annotations) do
          [@annotation]
        end

        it "should generate the expected annotation table" do
          subject.should == <<-EOS.unindent
            >Feature\tsomething\tannotation_table
            1\t3\tgene
          EOS
        end

      end

      context "two genes" do

        let(:annotations) do
          [@annotation,@annotation.clone.start(4).end(6)]
        end

        it "should generate the expected annotation table" do
          subject.should == <<-EOS.unindent
            >Feature\tsomething\tannotation_table
            1\t3\tgene
            4\t6\tgene
          EOS
        end

      end

      context "one reversed gene" do

        let(:annotations) do
          [@annotation.clone.strand('-')]
        end

        it "should generate the expected annotation table" do
          subject.should == <<-EOS.unindent
            >Feature\tsomething\tannotation_table
            3\t1\tgene
          EOS
        end

      end

      context "one gene with attributes" do

        let(:annotations) do
          [@annotation.clone.attributes({'ID' => 'gene1'})]
        end

        it "should generate the expected annotation table" do
          subject.should == <<-EOS.unindent
            >Feature\tsomething\tannotation_table
            1\t3\tgene
            \t\t\tID\tgene1
          EOS
        end

      end

      context "one gene with the ID field specified" do

        let(:metadata) do
          {:identifier => 'something', :annotation_id_field => 'ID'}
        end

        let(:annotations) do
          [@annotation.clone.attributes({'ID' => 'gene1'})]
        end

        it "should generate the expected annotation table" do
          subject.should == <<-EOS.unindent
            >Feature\tsomething\tannotation_table
            1\t3\tgene
            \t\t\tlocus_tag\tgene1
          EOS
        end

      end

      context "one gene with the ID prefixed" do

        let(:metadata) do
          {:identifier => 'something', :annotation_id_field => 'ID',
           :annotation_id_field_prefix => 'S_'}
        end

        let(:annotations) do
          [@annotation.clone.attributes({'ID' => 'gene1'})]
        end

        it "should generate the expected annotation table" do
          subject.should == <<-EOS.unindent
            >Feature\tsomething\tannotation_table
            1\t3\tgene
            \t\t\tlocus_tag\tS_gene1
          EOS
        end

      end

      context "one gene with the ID field mapped to locus_tag" do

        let(:metadata) do
          {:identifier => 'something', :map_annotations => {'something' => 'other'}}
        end

        let(:annotations) do
          [@annotation.clone.attributes({'something' => 'gene1'})]
        end

        it "should generate the expected annotation table" do
          subject.should == <<-EOS.unindent
            >Feature\tsomething\tannotation_table
            1\t3\tgene
            \t\t\tother\tgene1
          EOS
        end

      end

      context "four genes with the the ID reset" do

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
            1\t3\tgene
            \t\t\tlocus_tag\t000001
            4\t6\tgene
            \t\t\tlocus_tag\t000002
            7\t9\tgene
            \t\t\tlocus_tag\t000003
            10\t12\tgene
            \t\t\tlocus_tag\t000004
          EOS
        end

      end

    end

  end

end
