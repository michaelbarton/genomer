class Genomer::OutputType::Table < Genomer::OutputType

  SUFFIX = 'tbl'

  def generate
    process
    render
  end

  def process
    rename_protein_annotations
    filter_non_protein_annotations

    if @rules.reset_annotation_id_field?
      reset_annotation_id_field
    end
    prefix_annotation_id_field @rules.annotation_id_field_prefix
  end

  def render
    delimiter = "\t"
    indent    = delimiter * 2

    out = [%W|>Feature #{identifier} annotation_table|]
    annotations.map{|i| i.to_genbank_feature_row}.each do |row|
      out << row.shift
      row.each{|i| out << i.unshift(indent) }
    end
    out.map{|line| line * delimiter} * "\n" + "\n"
  end

  def prefix_annotation_id_field(prefix)
    return unless prefix
    annotations.each{|attn| attn.id.insert(0,prefix) }
  end

  def reset_annotation_id_field
    annotations.each_with_index do |annotation,count|
      annotation.id = sprintf("%06d",count+1)
    end
  end

  def filter_non_protein_annotations
    annotations.reject! do |attn|
      ! (attn.feature == 'gene' || attn.feature == 'CDS')
    end
  end

  def rename_protein_annotations
    annotations.select{|i| i.feature == 'CDS'}.each do |attn|
      attn.id = parent_gene(attn).id.clone
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

end
