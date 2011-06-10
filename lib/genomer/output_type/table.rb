class Genomer::OutputType::Table < Genomer::OutputType
  SUFFIX = 'tbl'

  def generate
    out = ">Feature\t#{@rules.identifier}\tannotation_table\n"
    annotations.each do |annotation|
      out << [annotation.start,annotation.end,annotation.feature] * "\t"
      out << "\n"
    end
    out
  end

end
