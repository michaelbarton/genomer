class Genomer::OutputType

  def self.[](output_type)
    self.const_get(output_type.to_s.capitalize)
  end

end
