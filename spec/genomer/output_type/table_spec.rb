require 'spec_helper'

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

  describe "#process" do

    subject do
      table = described_class.new(generate_rules(
        sequences,annotations,metadata))
      table.process
      table.annotations
    end

    context "with no annotations" do

      let(:annotations) do
        []
      end

      it "should return an empty annotation array" do
        subject.should == []
      end

    end

    context "with gene features: " do

      context "one gene" do

        let(:annotations) do
          [@gene]
        end

        it "should return the gene" do
          expected = annotations.first.clone
          expected = expected.seqname('scaffold').to_gff3_record

          subject.first.should have_same_fields(expected)
        end

      end

    end

    context "with cds features: " do

      context "one cds" do

        let(:annotations) do
          [@gene,@rna,@cds]
        end

        its(:length){should == 2}

        it "should contain the gene" do
          expected = @gene.clone.seqname('scaffold')
          expected = expected.to_gff3_record

          subject.first.should have_same_fields(expected)
        end

        it "should contain the cds" do
          expected = @cds.clone
          expected.seqname('scaffold')
          expected.attributes([["Parent","rna1"],['ID','gene1']])
          expected = expected.to_gff3_record

          subject.last.should have_same_fields(expected)
        end

      end

      context "one cds with the ID prefixed" do

        let(:metadata) do
          {:id_prefix => 'S_'}
        end

        let(:annotations) do
          [@gene,@rna,@cds]
        end

        its(:length){should == 2}

        it "should contain the gene" do
          expected = @gene.clone
          expected.seqname('scaffold')
          expected.attributes([['ID','S_gene1']])
          expected = expected.to_gff3_record

          subject.first.should have_same_fields(expected)
        end

        it "should contain the cds" do
          expected = @cds.clone
          expected.seqname('scaffold')
          expected.attributes([["Parent","rna1"],['ID','S_gene1']])
          expected = expected.to_gff3_record

          subject.last.should have_same_fields(expected)
        end

      end

      context "one cds with the ID reset" do

        let(:metadata) do
          {:reset_id => true}
        end

        let(:annotations) do
          [@gene,@rna,@cds]
        end

        its(:length){should == 2}

        it "should contain the gene" do
          expected = @gene.clone
          expected.seqname('scaffold')
          expected.attributes([['ID','000001']])
          expected = expected.to_gff3_record

          subject.first.should have_same_fields(expected)
        end

        it "should contain the cds" do
          expected = @cds.clone
          expected.seqname('scaffold')
          expected.attributes([["Parent","rna1"],['ID','000001']])
          expected = expected.to_gff3_record

          subject.last.should have_same_fields(expected)
        end

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

      let(:annotations) do
        []
      end

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
