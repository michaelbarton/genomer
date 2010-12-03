RSpec::Matchers.define :subclass_genomer_output_type do
  match do |actual|
    actual.superclass == Genomer::OutputType
  end

  description do |actual|
    "#{actual} should subclass Genomer::OutputType"
  end
end

RSpec::Matchers.define :define_the_suffix_constant_as do |expected|
  match do |actual|
    actual.const_get('SUFFIX').should == expected
  end
end

RSpec::Matchers.define :generate_the_sequence do |expected|
  match do |outputter|
    output = outputter.generate
    raise ArgumentError.new("Generated output is nil") if output.nil?
    sequence = Bio::FlatFile.auto(StringIO.new(output)){ |out| out.first.seq }
    sequence == expected
  end
end
