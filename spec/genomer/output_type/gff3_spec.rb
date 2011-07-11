require 'spec/spec_helper'

describe Genomer::OutputType::Gff3 do

  describe "class contants" do
    it{ described_class.should define_the_suffix_constant_as('gff') }
    it{ described_class.should subclass_genomer_output_type }
    it{ described_class.instance_methods.should include("generate")}

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

    context "with features: " do

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

      context "one gene with the ID reset" do

        let(:metadata) do
          {:reset_id => true}
        end

        let(:annotations) do
          [@gene]
        end

        it "should contain the gene" do
          expected = @gene.clone
          expected.seqname('scaffold')
          expected.attributes([['ID','000001']])
          expected = expected.to_gff3_record

          subject.first.should have_same_fields(expected)
        end

      end

      context "one cds with the ID prefixed" do

        let(:metadata) do
          {:id_prefix => 'S_'}
        end

        let(:annotations) do
          [@gene]
        end

        it "should contain the gene" do
          expected = @gene.clone
          expected.seqname('scaffold')
          expected.attributes([['ID','S_gene1']])
          expected = expected.to_gff3_record

          subject.first.should have_same_fields(expected)
        end

      end

    end

  end

  describe "#render" do

    let(:annotations) do
      [@gene]
    end

    it "should produce a gff3 string" do
      expected = Bio::GFF::GFF3.new
      ants = annotations.map do |i|
        i.clone.seqname('scaffold').to_gff3_record
      end
      expected.records = ants
      subject.render.should == expected.to_s
    end

  end

end
