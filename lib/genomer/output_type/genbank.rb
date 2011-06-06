class Genomer::OutputType::Genbank < Genomer::OutputType

  SUFFIX = 'gb'

  METADATA_MAP = {
    :entry_id => :identifier,
    :definition => :description
  }

  def generate
    build = Bio::Sequence.new(sequence)
    METADATA_MAP.each do |a,b|
      value = @rules.send(b)
      build.send(a.to_s + '=',value) unless value.nil?
    end
    build.output(:genbank)
  end

end
