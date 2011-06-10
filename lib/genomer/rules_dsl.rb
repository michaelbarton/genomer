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

end
