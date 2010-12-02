class Genomer::Runtime

  def configure(rules_file)
    dsl = Genomer::RulesDSL.new
    dsl.instance_eval File.read(rules_file)
    dsl
  end

end
