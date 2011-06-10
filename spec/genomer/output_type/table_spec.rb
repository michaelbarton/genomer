require 'spec/spec_helper'

describe Genomer::OutputType::Table do

  describe "class contants" do
    it{ described_class.should define_the_suffix_constant_as('tbl') }
    it{ described_class.should subclass_genomer_output_type }
  end

  subject{ described_class.new(rules).generate }

  let(:sequences) do
    [Sequence.new(:name => 'seq1', :sequence => 'ATG')]
  end


  describe "#generate" do

    context "using an empty annotation set" do

      let(:rules) do
        generate_rules(sequences)
      end

      it "should generate an empty annotation table" do
        subject.should == ">Feature\n"
      end

    end

  end

end
