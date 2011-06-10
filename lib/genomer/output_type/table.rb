class Genomer::OutputType::Table < Genomer::OutputType
  SUFFIX = 'tbl'

  def generate
    out = ">Feature\t#{@rules.identifier}\tannotation_table\n"
    annotations.each do |annotation|
      out << map_annotation(annotation) * "\t"
      out << "\n"
    end
    out
  end

  def map_annotation(annotation)
    if annotation.strand == '+'
      [annotation.start,annotation.end,annotation.feature]
    else
      [annotation.end,annotation.start,annotation.feature]
    end
  end


end
