# Problems with temporary files being unlinked.
# Manually controlling garbage collection solves
# this
GC.disable

def generate_rules(sequences,annotations = [],options = Hash.new)

  GC.start

  scaffold,sequence = generate_scaffold_files(sequences)

  rules = Genomer::RulesDSL.new
  rules.scaffold_file   scaffold.path
  rules.sequence_file   sequence.path

  annotation = generate_gff3_file(annotations)
  rules.annotation_file annotation.path

  options.each{|key,value| rules.send(key,value)}

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
