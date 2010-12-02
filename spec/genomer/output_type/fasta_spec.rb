require File.join(File.dirname(__FILE__),'..','..','spec_helper')

describe Genomer::OutputType::Fasta do

  before(:each) do
    @rules = Genomer::RulesDSL.new
    @scaffold,@sequence = scaffold_and_sequence(
      [{'name' => 'seq1', 'nucleotides' => 'ATGC' }])
  end

  it "should return the file name using the rules outfile name" do
    @rules.out_file_name 'genome'
    fasta = Genomer::OutputType::Fasta.new(@rules)
    fasta.file.should == 'genome.fna'
  end

  it "should generate the expected fasta sequence" do
    @rules.scaffold_file @scaffold
    @rules.sequence_file @sequence
    fasta = Genomer::OutputType::Fasta.new(@rules)
    fasta.generate.should == ">. \nATGC\n"
  end

end
