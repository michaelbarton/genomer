class Genomer::RulesDSL

  def scaffold_file(location=nil)
    return @scaffold if location.nil?
    @scaffold = location
  end

  def sequence_file(location=nil)
    return @sequence if location.nil?
    @sequence = location
  end

end
