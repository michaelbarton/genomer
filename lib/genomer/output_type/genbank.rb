class Genomer::OutputType::Genbank < Genomer::OutputType

  SUFFIX = 'gb'

  def generate
    Bio::Sequence.new(sequence).output(:genbank)
  end

end
