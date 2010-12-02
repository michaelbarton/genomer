class Genomer::OutputType::Fasta

  PREFIX = 'fna'

  def initialize(rules)
    @rules = rules
  end

  def file
    @rules.out_file_name + '.' + PREFIX
  end

  def generate
    scaffold = Scaffolder.new(YAML.load(File.read(@rules.scaffold_file)),
                              @rules.sequence_file)
    sequence = scaffold.inject(String.new){|build,e| build << e.sequence }
    Bio::Sequence.new(sequence).output(:fasta)
  end

end
