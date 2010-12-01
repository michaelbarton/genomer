class Genomer::RulesDSL

  def initialize
    @types = Array.new
  end

  def scaffold_file(location=nil)
    return @scaffold if location.nil?
    @scaffold = location
  end

  def sequence_file(location=nil)
    return @sequence if location.nil?
    @sequence = location
  end

  def output(*types)
    return @types if types.empty?
    @types.concat types
  end

end
