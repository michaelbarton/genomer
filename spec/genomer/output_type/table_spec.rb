require 'spec/spec_helper'

describe Genomer::OutputType::Table do

  describe "class contants" do
    it{ described_class.should define_the_suffix_constant_as('tbl') }
    it{ described_class.should subclass_genomer_output_type }
  end

  before do
    @annotation = Annotation.new(:seqname => 'seq1',
                                 :start => 1, :end => 3,:feature => 'gene')
  end

  subject do
    described_class.new(generate_rules(sequences,annotations,metadata))
  end

  let(:metadata) do
    []
  end

  let(:sequences) do
    [Sequence.new(:name => 'seq1', :sequence => 'ATG' * 4)]
  end

  let(:annotations) do
    []
  end

  describe "#reset_annotation_id_field" do

    let(:annotations) do
      [
        @annotation.clone.attributes({'ID' => 'gene1'}),
        @annotation.clone.attributes({'ID' => 'gene2'}).start(4).end(6),
        @annotation.clone.attributes({'ID' => 'gene3'}).start(7).end(9),
        @annotation.clone.attributes({'ID' => 'gene4'}).start(10).end(12)
      ]
    end

    it "should update the id field for the annotations" do
      subject.reset_annotation_id_field
      ids = subject.annotations.map{|i| i.id}
      ids.should == ['000001','000002','000003','000004']
    end

  end

  describe "#prefix_annotation_id_field" do

      let(:annotations) do
        [
          @annotation.clone.attributes({'ID' => 'gene1'}),
          @annotation.clone.attributes({'ID' => 'gene2'}).start(4).end(6),
          @annotation.clone.attributes({'ID' => 'gene3'}).start(7).end(9),
          @annotation.clone.attributes({'ID' => 'gene4'}).start(10).end(12)
        ]
      end

      context "passed nil" do

        it "should update the id field for the annotations" do
          subject.prefix_annotation_id_field(nil)
          ids = subject.annotations.map{|i| i.id}
          ids.should == ["gene1","gene2","gene3","gene4"]
        end

      end

      context "passed a string" do

        it "should update the id field for the annotations" do
          subject.prefix_annotation_id_field("S_")
          ids = subject.annotations.map{|i| i.id}
          ids.should == ["S_gene1","S_gene2","S_gene3","S_gene4"]
        end

      end

  end

  describe "#render" do

    subject do
      described_class.new(generate_rules(sequences,annotations,metadata)).render
    end

    let(:metadata) do
      {:identifier => 'something'}
    end

    context "with no annotations" do

      it "should return an empty annotation table" do
        subject.should == ">Feature\tsomething\tannotation_table\n"
      end

    end

    context "with gene features: " do

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

      context "one gene with attributes" do

        let(:annotations) do
          [@annotation.clone.attributes({'one' => 'two'})]
        end

        it "should generate the expected annotation table" do
          subject.should == <<-EOS.unindent
            >Feature\tsomething\tannotation_table
            1\t3\tgene
            \t\t\tone\ttwo
          EOS
        end

      end

      context "one gene with an ID attribute" do

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

    end

  end

  describe "#feature_array" do

    subject do
      described_class.feature_array annotation.to_gff3_record
    end

    context "a simple annotation" do

      let(:annotation) do
        @annotation
      end

      it "should return an array for the annotation" do
        subject.should == [annotation.start,annotation.end,
                          annotation.feature]
      end

    end

    context "a reversed annotation" do

      let(:annotation) do
        @annotation.clone.strand('-')
      end

      it "should reverse the starnd and end coordinates" do
        subject.should == [annotation.end,annotation.start,
                          annotation.feature]
      end

    end

  end

end
