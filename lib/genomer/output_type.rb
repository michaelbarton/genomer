require 'scaffolder'

class Genomer::OutputType

  def self.[](output_type)
    self.const_get(output_type.to_s.capitalize)
  end

  require 'genomer/output_type/fasta'
end
