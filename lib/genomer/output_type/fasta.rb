class Genomer::OutputType::Fasta < Genomer::OutputType

  SUFFIX = 'fsa'

  def generate
    header = identifier ? identifier : ". "
    if @rules.metadata
      header << @rules.metadata.map{ |k,v| "[#{k}=#{v}]"} * ' '
    end
    Bio::Sequence.new(sequence).output(:fasta,:header => header)
  end

end
