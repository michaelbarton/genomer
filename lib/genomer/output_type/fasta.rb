class Genomer::OutputType::Fasta < Genomer::OutputType

  SUFFIX = 'fna'

  def generate
    options = Hash.new
    options[:header] = identifier if identifier
    Bio::Sequence.new(sequence).output(:fasta,options)
  end

end
