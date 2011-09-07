require 'psych'
require 'scaffolder'
require 'scaffolder/annotation_locator'

class Genomer::OutputType

  def self.[](output_type)
    self.const_get(output_type.to_s.capitalize)
  end

  def initialize(rules)
    @rules = rules
  end

  def file
    file = @rules.out_file_name + '.' + self.class.const_get("SUFFIX")
    @rules.out_dir_name ? File.join(@rules.out_dir_name,file) : file
  end

  def sequence
    scaffold = Scaffolder.new(Psych.load(File.read(@rules.scaffold_file)),
                              @rules.sequence_file)
    scaffold.inject(String.new){|build,e| build << e.sequence }
  end

  def annotations
    if @__annotations__
      return @__annotations__
    else
      if @rules.annotation_file
        unsorted = Scaffolder::AnnotationLocator.new(
          @rules.scaffold_file,
          @rules.sequence_file,
          @rules.annotation_file)
        @__annotations__ = unsorted.sort_by do |attn|
          [attn.start,attn.end]
        end
      else
        @__annotations__ = Array.new
      end
      return annotations
    end
  end

  def identifier
    @rules.identifier
  end

  def prefix_id(prefix)
    return unless prefix
    genes = annotations.select{|i| i.feature == 'gene'}
    genes.each{|attn| attn.id.insert(0,prefix) }
  end

  def reset_id
    genes = annotations.select{|i| i.feature == 'gene'}
    genes.each_with_index do |annotation,count|
      annotation.id.replace sprintf("%06d",count+1)
    end
  end

  def filter_non_protein_annotations
    annotations.reject! do |attn|
      ! (attn.feature == 'gene' || attn.feature == 'CDS')
    end
  end

  def link_cds_id_to_parent_gene_id
    annotations.select{|i| i.feature == 'CDS'}.each do |attn|
      attn.id = parent_gene(attn).id
    end
  end

  def parent_gene(attn)
    if attn.feature == 'gene'
      return attn
    else
      return parent_gene(
        annotation_id_map[attn.get_attribute('Parent')])
    end
  end

  def annotation_id_map
    if @__id_map__
      return @__id_map__
    else
      @__id_map__ = annotations.inject(Hash.new) do |hash,attn|
        hash[attn.id] = attn
        hash
      end
      return annotation_id_map
    end
  end

  # Load all output_type ruby files
  Dir[File.join(File.dirname(__FILE__),'output_type','*.rb')].each do |f|
    require File.expand_path(f)
  end
end
