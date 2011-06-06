class Genomer::OutputType::Genbank < Genomer::OutputType

  SUFFIX = 'gb'

  def generate
    build = Bio::Sequence.new(sequence)
    build.entry_id = @rules.identifier if @rules.identifier
    build.definition = @rules.description if @rules.description
    build.output(:genbank)
  end

end
