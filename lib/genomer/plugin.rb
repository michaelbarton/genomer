require 'scaffolder'

class Genomer::Plugin

  def self.[](short_name)
    plugin = plugins.detect{|i| i.name == "genomer-plugin-#{short_name}" }
    unless plugin 
      error =  "Unknown command or plugin '#{short_name}.'\n"
      error << "run `genomer help` for a list of available commands\n"
      raise GenomerError, error
    end
    require plugin.name
    Kernel.const_get(to_class_name(plugin.name))
  end

  def self.plugins
    require 'bundler'
    Bundler.setup.gems.select{|gem| gem.name =~ /genomer-plugin-.+/ }
  end

  def self.to_class_name(string)
    string.split('-').map{|i| i.capitalize}.join
  end

  def scaffold
    assembly = Pathname.new('assembly')
    sequence_file = assembly + 'sequence.fna'
    scaffold_file = assembly + 'scaffold.yml'
    Scaffolder.new(YAML.load(File.open(scaffold_file)),sequence_file)
  end

end
