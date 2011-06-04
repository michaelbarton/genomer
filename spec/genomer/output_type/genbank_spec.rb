require 'spec/spec_helper'

describe Genomer::OutputType::Genbank do

  describe "class contants" do
    it{ described_class.should define_the_suffix_constant_as('gb') }
    it{ described_class.should subclass_genomer_output_type }
  end

  subject{ described_class.new(rules) }

  describe "creating a basic Genbank file" do
    let(:rules){ simple_rules [{'name' => 'seq1', 'nucleotides' => 'ATGC' }] }

    it{ should generate_the_sequence('ATGC') }
    it{ should generate_the_format_type(:genbank) }
  end

  describe "setting the locus in a Genbank file" do
    let(:rules){ simple_rules [{'name' => 'seq1', 'nucleotides' => 'ATGC',
      'indentifier' => 'something' }] }

    its(:generate){ should match(/LOCUS\s+something/)}
  end

end
