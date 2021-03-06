require 'scaffolder'
require 'scaffolder/annotation_locator'

# Superclass for genomer plugins which us the genomer plugin. This class
# implements the common API which plugins should use to interact with the
# genomer system
class Genomer::Plugin

  # Return the corresponding class for this plugin name.
  #
  # This method calls {Kernel#require} for the requested plugin by searching
  # the available plugins for genomer-plugin-NAME. Where name is the passed
  # string. The class for this plugin is then returned.
  #
  # @param [String] name The name of plugin without the 'genomer-plugin-' prefix.
  # @return [Class] The class for this genomer plugin.
  def self.[](plugin)
    name = fetch(plugin).name
    require name
    Kernel.const_get(to_class_name(name))
  end

  def self.fetch(name)
    plugin = plugins.detect{|i| i.name == "genomer-plugin-#{name}" }
    unless plugin 
      error =  "Unknown command or plugin '#{name}.'\n"
      error << "run `genomer help` for a list of available commands\n"
      raise Genomer::Error, error
    end
    plugin
  end

  private

  # All the avaiable gems with a matching genomer-plugin- prefix.
  #
  # @return [Array] An array of genomer plugin gems
  def self.plugins
    require 'bundler'
    Bundler.setup.gems.select{|gem| gem.name =~ /genomer-plugin-.+/ }
  end

  # Convert hyphen separated list of words to camel case
  #
  # @param [String] Hyphen separate string
  # @return [String] Camel case string
  def self.to_class_name(string)
    string.split('-').map{|i| i.capitalize}.join
  end

  public

  # @return [Array] List of command line arguments
  attr :arguments

  # @return [Hash] Command line flags as where --flag=value is :flag => value
  attr :flags

  attr :sequence_file
  attr :scaffold_file
  attr :annotation_file

  # Initialize plugin with passed command line parameters.
  #
  # This create a plugin instance with the command line arguments and instance set as
  # instance variables. These command line arguments are passed by the
  # Genomer::Runtime.
  #
  # @param [Array] arguments List of command arguments
  # @param [Hash] settings Command line flags as :flag => value
  def initialize(arguments,flags)
    @arguments = arguments
    @flags     = flags

    assembly = Pathname.new('assembly')
    @sequence_file   = assembly + 'sequence.fna'
    @scaffold_file   = assembly + 'scaffold.yml'
    @annotation_file = assembly + 'annotations.gff'
  end

  # The genome scaffold constructed from the files in the "ROOT/assembly/" directory.
  #
  # @return [Array] An array of Scaffolder::Region instances
  def scaffold
    YAML::ENGINE.yamler = 'syck' if defined?(YAML::ENGINE) and Gem::Version.new(RUBY_VERSION.dup) < Gem::Version.new('2.0.0')
    Scaffolder.new(YAML.load(File.read(scaffold_file)),sequence_file)
  end

  def annotations(options = {})
    attns = Scaffolder::AnnotationLocator.new(
      scaffold_file,sequence_file,annotation_file)

    attns = attns.sort_by{|attn| [attn.start,attn.end] }

    if value = options[:reset]
      start = value.to_s =~ /^[-+]?[0-9]+$/ ? value.to_i : 1

      genes = attns.select{|i| i.feature == 'gene'}
      genes.each_with_index do |annotation,count|
        annotation.id.replace sprintf("%06d",count + start)
      end
    end

    if prefix = options[:prefix]
      genes = attns.select{|i| i.feature == 'gene'}
      genes.each{|attn| attn.id.insert(0,prefix) }
    end

    attns
  end

  # This method should be overriden to perform this plugin's operation.
  #
  # The run method is called on the plugin by Genomer::Runtime. This should be
  # overridden in subclasses to perform the intended function. If an error is
  # encountered raise a Genomer::Error with a description. This will be caught
  # and the error message printed to the standard out.
  #
  # @return [String] The string output of this plugin. This is
  # subsequently output to the command line
  def run
  end

end
