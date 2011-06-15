require 'spec/spec_helper'

describe Genomer::OutputType::Fasta do


  describe "class contants" do
    it{ described_class.should define_the_suffix_constant_as('fna') }
    it{ described_class.should subclass_genomer_output_type }
  end

  describe "#generate" do

    before do
      @sequence = Sequence.new(:name => 'seq1', :sequence => 'ATGC')
    end

    subject do
      described_class.new(rules).generate
    end

    describe "with a simple sequence" do

      let(:rules) do
        generate_rules([@sequence])
      end

      it "should generate the expected fasta" do
        subject.should == <<-EOS.unindent
          >. 
          ATGC
        EOS
      end

    end

    describe "with an identifier" do

      let(:rules) do
        generate_rules([@sequence],[],{:identifier => 'something'})
      end

      it "should generate the expected fasta" do
        subject.should == <<-EOS.unindent
          >something
          ATGC
        EOS
      end

    end

  end

end
