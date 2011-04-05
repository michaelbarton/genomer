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

  def annotation_file(location=nil)
    return @annotation_file if location.nil?
    @annotation_file = location
  end

  def out_file_name(name=nil)
    return @out_file_name if name.nil?
    @out_file_name = name
  end

  def out_dir_name(name=nil)
    return @out_dir_name if name.nil?
    @out_dir_name = name
  end

  def output(*types)
    return @types if types.empty?
    @types.concat types
  end

  def identifier(arg=nil)
    return @identifier if arg.nil?
    @identifier = arg
  end

  def description(arg=nil)
    return @description if arg.nil?
    @description = arg
  end

end
