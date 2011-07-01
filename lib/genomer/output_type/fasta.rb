class Genomer::OutputType::Fasta < Genomer::OutputType

  SUFFIX = 'fsa'

  def generate
    header = Array.new
    header << (identifier || ".")
    header << @rules.metadata.map{|k,v| "[#{k}=#{v}]"} if @rules.metadata

    Bio::Sequence.new(sequence).output(:fasta,:header => (header * ' '))
  end

end
