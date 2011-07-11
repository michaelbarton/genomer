require 'spec/spec_helper'

describe Genomer::OutputType do

  it "should have have a method to fetch OutputType subclasses" do
    Genomer::OutputType::Type = Class.new
    Genomer::OutputType['type'].should == Genomer::OutputType::Type
    Genomer::OutputType[:type].should == Genomer::OutputType::Type
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

  describe "#reset_id" do

    context "with gene only annotations" do

      let(:annotations) do
        [
          @gene,
          @gene.clone.attributes({'ID' => 'gene2'}).start(4).end(6),
        ]
      end

      it "should update the id field for the annotations" do
        subject.reset_id
        ids = subject.annotations.map{|i| i.id}
        ids.should == ['000001','000002']
      end

      it "should maintain the same string object" do
        before = subject.annotations.first.id
        subject.reset_id
        after = subject.annotations.first.id
        before.object_id.should == after.object_id
      end
    end

    context "with gene and cds annotations" do

      let(:annotations) do
        [@gene,@rna,@cds]
      end

      it "should only update the id field of the gene" do
        subject.reset_id
        ids = subject.annotations.map{|i| i.id}
        ids.should == ['000001','rna1','cds1']
      end

      it "should maintain the same string object" do
        before = subject.annotations.first.id
        subject.reset_id
        after = subject.annotations.first.id
        before.object_id.should == after.object_id
      end

    end

  end

  describe "#prefix_annotation_id_field" do

      context "passed nil" do

        let(:annotations) do
          [@gene]
        end

        it "should update the id field for the annotations" do
          subject.prefix_id(nil)
          ids = subject.annotations.map{|i| i.id}
          ids.should == ["gene1"]
        end

      end

      context "passed a string" do

        context "with gene annotations only" do

          let(:annotations) do
            [@gene]
          end

          it "should update the id field for the gene" do
            subject.prefix_id("S_")
            ids = subject.annotations.map{|i| i.id}
            ids.should == ["S_gene1"]
          end

        end

        context "with gene and cds annotations" do

          let(:annotations) do
            [@gene,@rna,@cds]
          end

          it "should only prefix the gene annotation id" do
            subject.prefix_id("S_")
            ids = subject.annotations.map{|i| i.id}
            ids.should == ["S_gene1","rna1","cds1"]
          end

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

  describe "#link_cds_id_to_parent_gene_id" do

    subject do
      table = described_class.new(generate_rules(
        sequences,annotations,metadata))
      table.link_cds_id_to_parent_gene_id
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

      it "should link the cds ID to the gene ID" do
        cds  = subject.select{|i| i.feature == 'CDS'}.first
        gene = subject.select{|i| i.feature == 'gene'}.first
        cds.id.should equal(gene.id)
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

end
