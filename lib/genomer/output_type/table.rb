class Genomer::OutputType::Table < Genomer::OutputType
  SUFFIX = 'tbl'

  def generate
    ">Feature\t#{@rules.identifier}\tannotation_table\n"
  end

end
