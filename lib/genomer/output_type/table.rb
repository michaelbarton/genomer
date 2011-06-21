class Genomer::OutputType::Table < Genomer::OutputType

  SUFFIX = 'tbl'

  ID_FIELD  = 'locus_tag'

  def generate
    if @rules.reset_annotation_id_field?
      reset_annotation_id_field
    end
    prefix_annotation_id_field @rules.annotation_id_field_prefix

    render
  end

  def render
    delimiter = "\t"
    indent    = delimiter * 2

    out = [%W|>Feature #{identifier} annotation_table|]
    annotations.each do |attn|
      out << self.class.feature_array(attn)
      attn.attributes.each do |attr|
        if attr.first == 'ID'
          out << [indent,ID_FIELD,attr.last]
        else
          out << attr.unshift(indent)
        end
      end
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

  def self.feature_array(annotation)
    if annotation.negative_strand?
      [annotation.end,annotation.start,annotation.feature]
    else
      [annotation.start,annotation.end,annotation.feature]
    end
  end

end
