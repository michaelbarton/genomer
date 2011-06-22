require 'spec/spec_helper'

describe Genomer::OutputType::Table do

  describe "class contants" do
    it{ described_class.should define_the_suffix_constant_as('tbl') }
    it{ described_class.should subclass_genomer_output_type }
  end

  before do
    @gene = Annotation.new(:seqname => 'seq1',
                           :start => 1, :end => 3,
                           :feature => 'gene',
                           :attributes => {'ID' => 'gene1'}
                          )
    @rna = @gene.clone.feature('mRNA').
      attributes('ID' => 'rna1', 'Parent' => 'gene1')
    @cds = @gene.clone.feature('CDS').
      attributes('ID' => 'cds1', 'Parent' => 'rna1')
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
        @gene,
        @gene.clone.attributes({'ID' => 'gene2'}).start(4).end(6),
        @gene.clone.attributes({'ID' => 'gene3'}).start(7).end(9),
        @gene.clone.attributes({'ID' => 'gene4'}).start(10).end(12)
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
          @gene,
          @gene.clone.attributes({'ID' => 'gene2'}).start(4).end(6),
          @gene.clone.attributes({'ID' => 'gene3'}).start(7).end(9),
          @gene.clone.attributes({'ID' => 'gene4'}).start(10).end(12)
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

  describe "#filter_non_protein_annotations" do

    subject do
      table = described_class.new(generate_rules(
        sequences,annotations,metadata))
      table.filter_non_protein_annotations
      table.annotations
    end

    context "with one gene annotation" do

      let(:annotations) do
        [@gene]
      end

      its(:length){should == 1}

      it "should preserve the gene annotations" do
        subject.first.feature.should == "gene"
      end

    end

    context "with a gene and rna annotations" do

      let(:annotations) do
        [@gene,@rna]
      end

      its(:length){should == 1}

      it "should preserve the gene annotations" do
        subject.first.feature.should == "gene"
      end

    end

    context "with a gene, rna and cds annotations" do

      let(:annotations) do
        [@gene,@rna,@cds]
      end

      its(:length){should == 2}

      it "should preserve the gene annotation" do
        subject.first.feature.should == "gene"
      end

      it "should preserve the cds annotation" do
        subject.first.feature.should == "gene"
      end

    end

  end

  describe "#rename_protein_annotations" do

    subject do
      table = described_class.new(generate_rules(
        sequences,annotations,metadata))
      table.rename_protein_annotations
      table.annotations
    end

    context "with no cds annotations" do

      let(:annotations) do
        [@gene]
      end

      it "should preserve the gene annotation ID" do
        subject.first.id.should == "gene1"
      end

    end

    context "with a cds annotation" do

      let(:annotations) do
        [@gene,@rna,@cds]
      end

      it "should preserve the gene annotation ID" do
        subject.first.id.should == "gene1"
      end

      it "should rename the cds annotation ID field" do
        cds = subject.select{|i| i.feature == 'CDS'}.first
        cds.id.should == "gene1"
      end

    end

  end

  describe "#parent_gene" do


    subject do
      table = described_class.new(generate_rules(
        sequences,annotations,metadata))
    end

    let(:annotations) do
      [@gene,@rna,@cds]
    end

    it "should return the parent annotation of a cds" do
      cds = @cds.to_gff3_record
      subject.parent_gene(cds).id.should == 'gene1'
    end

  end

  describe "#annotation_id_map" do

    before do
      @gene.attributes('ID' => 'gene1')
      @rna = @gene.clone.feature('mRNA').
        attributes('ID' => 'rna1', 'Parent' => 'gene1')
      @cds = @gene.clone.feature('CDS').
        attributes('ID' => 'cds1', 'Parent' => 'rna1')
    end

    subject do
      table = described_class.new(generate_rules(
        sequences,annotations,metadata))
      table.annotation_id_map
    end

    context "from one annotation" do

      let(:annotations) do
        [@gene]
      end

      its("keys.length"){should == 1}

      it "should store the annotations by ID" do
        subject['gene1'].feature.should == 'gene'
      end

    end

    context "from several annotation" do

      let(:annotations) do
        [@gene,@rna,@cds]
      end

      its("keys.length"){should == 3}

      it "should store the annotations by ID" do
        subject['gene1'].feature.should == 'gene'
        subject['rna1'].feature.should == 'mRNA'
        subject['cds1'].feature.should == 'CDS'
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

    context "with gene feature: " do

      context "one gene" do

        let(:annotations) do
          [@gene.attributes({})]
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
          [@gene.attributes({}),
           @gene.clone.attributes({}).start(4).end(6)]
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
          [@gene.clone.attributes({'one' => 'two'})]
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
          [@gene.clone.attributes({'ID' => 'gene1'})]
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
          [@gene.clone.strand('-').attributes({})]
        end

        it "should generate the expected annotation table" do
          subject.should == <<-EOS.unindent
            >Feature\tsomething\tannotation_table
            3\t1\tgene
          EOS
        end

      end

    end

    context "with a cds feature: " do

      context "one cds" do

        let(:annotations) do
          [@cds]
        end

        it "should generate the expected annotation table" do
          subject.should == <<-EOS.unindent
            >Feature\tsomething\tannotation_table
            1\t3\tCDS
            \t\t\tprotein_id\tgnl|ncbi|cds1
          EOS
        end

      end

    end

  end

end
