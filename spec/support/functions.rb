
def scaffold_and_sequence(entries)
  scaffold = write_scaffold_file(entries.map do |entry|
    {'sequence' => {'source' => entry['name']}}
  end)
  sequence = write_sequence_file(entries.map do |entry|
    {:name => entry['name'], :sequence => entry['nucleotides']}
  end)
  [scaffold,sequence]
end

def write_sequence_file(*sequences)
  file = Tempfile.new("sequence").path
  File.open(file,'w') do |tmp|
    sequences.flatten.each do |sequence|
      seq = Bio::Sequence.new(sequence[:sequence])
      tmp.print(seq.output(:fasta,:header => sequence[:name]))
    end
  end
  file
end

def write_scaffold_file(scaffold)
  file = Tempfile.new("scaffold").path
  File.open(file,'w'){|tmp| tmp.print(YAML.dump(scaffold))}
  file
end

def simple_rules(sequences)
  rules = Genomer::RulesDSL.new
  scaffold,sequence = scaffold_and_sequence(sequences)

  rules.scaffold_file scaffold
  rules.sequence_file sequence
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
