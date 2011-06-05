def generate_rules(sequences)
  rules = Genomer::RulesDSL.new
  scaffold,sequence = generate_scaffold_files(sequences)

  rules.scaffold_file scaffold.path
  rules.sequence_file sequence.path
  rules
end

def parse_output(generated_output)
  output = generated_output
  raise ArgumentError.new("Generated output is nil") if output.nil?
  Bio::FlatFile.auto(StringIO.new(output))
end

def output_format(generated_string)
  bio_db_class = parse_output(generated_string).dbclass

  format = bio_db_class.name.split('::').last
  format = format[0..-7] if format =~ /Format/
  format.downcase.to_sym
end

def output_sequence(generated_string)
  parse_output(generated_string).first.seq
end
