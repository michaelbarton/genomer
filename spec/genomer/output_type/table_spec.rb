require 'spec/spec_helper'

describe Genomer::OutputType::Table do

  describe "class contants" do
    it{ described_class.should define_the_suffix_constant_as('tbl') }
    it{ described_class.should subclass_genomer_output_type }
  end

end
