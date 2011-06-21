require 'scaffolder'
require 'scaffolder/annotation_locator'

class Genomer::OutputType

  def self.[](output_type)
    self.const_get(output_type.to_s.capitalize)
  end

  def initialize(rules)
    @rules = rules
    @annotations = annotations.sort{|a,b| a.start <=> b.start }
  end

  def file
    file = @rules.out_file_name + '.' + self.class.const_get("SUFFIX")
    @rules.out_dir_name ? File.join(@rules.out_dir_name,file) : file
  end

  def sequence
    scaffold = Scaffolder.new(YAML.load(File.read(@rules.scaffold_file)),
                              @rules.sequence_file)
    scaffold.inject(String.new){|build,e| build << e.sequence }
  end

  def annotations
    if @__annotations__
      return @__annotations__
    else
      if @rules.annotation_file
        @__annotations__ = Scaffolder::AnnotationLocator.new(
          @rules.scaffold_file,
          @rules.sequence_file,
          @rules.annotation_file)
      else
        @__annotations__ = Array.new
      end
      return annotations
    end
  end

  def identifier
    @rules.identifier
  end

  # Load all output_type ruby files
  Dir[File.join(File.dirname(__FILE__),'output_type','*.rb')].each do |f|
    require File.expand_path(f)
  end
end
