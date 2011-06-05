require 'spec/spec_helper'

describe Genomer::OutputType::Genbank do

  subject do
    rules = generate_rules [Sequence.new(:name => 'seq1', :sequence => 'ATGC')]
    described_class.new(rules)
  end

  it{ should generate_the_sequence('ATGC') }
  it{ should generate_the_format_type(:genbank) }

  it{ described_class.should define_the_suffix_constant_as('gb') }
  it{ described_class.should subclass_genomer_output_type }

end
