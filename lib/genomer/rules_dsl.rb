class Genomer::RulesDSL

  def scaffold_file(location=nil)
    return @location if location.nil?
    @location = location
  end

end
