class Genomer::OutputType::Table < Genomer::OutputType
  SUFFIX = 'tbl'

  def generate
    ">Feature\n"
  end

end
