class Genomer::OutputType::Fasta < Genomer::OutputType

  SUFFIX = 'fna'

  def generate
    Bio::Sequence.new(sequence).output(:fasta)
  end

end
