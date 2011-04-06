require 'classy_adornments'

class Genomer::RulesDSL
  include ClassyAdornments

  adorn :scaffold_file
  adorn :sequence_file
  adorn :annotation_file

  adorn :out_file_name
  adorn :out_dir_name

  adorn :output, :array => true

  def identifier(arg=nil)
    return @identifier if arg.nil?
    @identifier = arg
  end

  def description(arg=nil)
    return @description if arg.nil?
    @description = arg
  end

end
