GENOMER = File.join %W| #{File.dirname(__FILE__)} .. .. bin genomer|

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
