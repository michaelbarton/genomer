class Genomer::OutputType::Gff3 < Genomer::OutputType

  SUFFIX = 'gff'

  def generate
    process
    render
  end

  def process
    reset_id if @rules.reset_id?
    prefix_id @rules.id_prefix
  end

  def render
    output = Bio::GFF::GFF3.new
    output.records = annotations
    output.to_s
  end

end
