class Genomer::OutputType::Table < Genomer::OutputType

  SUFFIX = 'tbl'

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

end
