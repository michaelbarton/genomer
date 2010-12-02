class Genomer::OutputType::Fasta < Genomer::OutputType

  SUFFIX = 'fna'

  def generate
    scaffold = Scaffolder.new(YAML.load(File.read(@rules.scaffold_file)),
                              @rules.sequence_file)
    sequence = scaffold.inject(String.new){|build,e| build << e.sequence }
    Bio::Sequence.new(sequence).output(:fasta)
  end

end
