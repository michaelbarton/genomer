require 'spec/spec_helper'

describe Genomer::OutputType::Gff3 do

  describe "class contants" do
    it{ described_class.should define_the_suffix_constant_as('gff') }
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

    end

  end

end
