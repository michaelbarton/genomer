RSpec::Matchers.define :subclass_genomer_output_type do
  match do |actual|
    actual.superclass == Genomer::OutputType
  end

  description do |actual|
    "#{actual} should subclass Genomer::OutputType"
  end
end

RSpec::Matchers.define :define_the_suffix_constant_as do |expected|
  match do |a|
    self.instance_variable_set(:@actual, a.const_get('SUFFIX'))
    actual == expected
  end
  diffable
end

RSpec::Matchers.define :generate_the_sequence do |expected|
  match do |outputter|
    sequence = output_sequence(outputter.generate)

    self.instance_variable_set(:@actual, sequence.upcase)
    self.instance_variable_set(:@expected, expected.upcase)
    actual == expected
  end
  diffable
end

RSpec::Matchers.define :generate_the_format_type do |expected|
  match do |outputter|
    format = output_format(outputter.generate)

    self.instance_variable_set(:@actual, format)
    actual == expected
  end
  diffable
end
