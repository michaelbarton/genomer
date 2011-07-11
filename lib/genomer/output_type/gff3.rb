class Genomer::OutputType::Gff3 < Genomer::OutputType

  SUFFIX = 'gff'

  def generate
    process
    render
  end

  def process
  end

  def render
    output = Bio::GFF::GFF3.new
    output.records = annotations
    output.to_s
  end

end
