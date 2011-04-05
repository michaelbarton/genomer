class Genomer::RulesDSL

  def initialize
    @types = Array.new
  end

  private

  def self.attribute(name)
    define_method(name) do |*arg|
      var = "@#{name}"
      unless arg.first # Is an argument is passed to the method?
        value = instance_variable_get(var)
        return value if value
      end
      instance_variable_set(var,arg.first)
    end
  end

  attribute :scaffold_file
  attribute :sequence_file
  attribute :annotation_file

  attribute :out_file_name
  attribute :out_dir_name

  public

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
