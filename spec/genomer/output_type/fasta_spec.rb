require 'spec/spec_helper'

describe Genomer::OutputType::Fasta do

  subject do
    rules = simple_rules [{'name' => 'seq1', 'nucleotides' => 'ATGC' }]
    described_class.new(rules)
  end

  it{ should generate_the_sequence('ATGC') }
  it{ should generate_the_format_type(:fasta) }

  it{ described_class.should define_the_suffix_constant_as('fna') }
  it{ described_class.should subclass_genomer_output_type }

end
