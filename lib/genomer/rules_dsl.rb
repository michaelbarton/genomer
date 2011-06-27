require 'classy_adornments'

class Genomer::RulesDSL
  include ClassyAdornments

  adorn :scaffold_file
  adorn :sequence_file
  adorn :annotation_file

  adorn :out_file_name
  adorn :out_dir_name

  adorn :output, :array => true

  adorn :identifier
  adorn :description
  adorn :metadata

  adorn :id_prefix

  def reset_id?
    ! @reset_annotation_id_field.nil?
  end

  def reset_id(arg = true)
    @reset_annotation_id_field = arg
  end

end
