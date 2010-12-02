require File.join(File.dirname(__FILE__),'..','..','spec_helper')

describe Genomer::OutputType::Fasta do

  before(:all) do
    @rules = Genomer::RulesDSL.new
    @scaffold,@sequence = scaffold_and_sequence(
      [{'name' => 'seq1', 'nucleotides' => 'ATGC' }])
  end

  it "should be a subclass of Genomer::OutputType" do
    Genomer::OutputType::Fasta.superclass.should == Genomer::OutputType
  end

  it "should define the suffix constant as 'fna'" do
    Genomer::OutputType::Fasta.const_get('SUFFIX').should == 'fna'
  end

  it "should generate the expected fasta sequence" do
    @rules.scaffold_file @scaffold
    @rules.sequence_file @sequence
    fasta = Genomer::OutputType::Fasta.new(@rules)
    fasta.generate.should == ">. \nATGC\n"
  end

end
