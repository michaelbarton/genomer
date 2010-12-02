class Genomer::Runtime

  attr :rules, true

  def initialize(rules_file)
    @rules = Genomer::RulesDSL.new
    @rules.instance_eval File.read(rules_file)
  end

  def execute!
    @rules.output.each do |output_type|
      outputter = Genomer::OutputType[output_type].new(@rules)
      File.open(outputter.file,'w') do |out|
        out.print outputter.generate
      end
    end
  end

end
