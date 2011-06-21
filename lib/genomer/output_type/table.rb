class Genomer::OutputType::Table < Genomer::OutputType
  SUFFIX = 'tbl'

  ID_FIELD  = 'locus_tag'

  def generate
    reset_annotation_id_field
    prefix_annotation_id_field

    complement_reverse_strand_annotations

    render
  end

  def render
    delimiter = "\t"
    indent    = delimiter * 2

    out = [%W|>Feature #{identifier} annotation_table|]
    @annotations.each do |attn|
      out << [attn.start,attn.end,attn.feature]
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

  private

  def prefix_annotation_id_field
    if @rules.annotation_id_field_prefix
      @annotations.each do |attn|
        attn.id.insert(0,@rules.annotation_id_field_prefix)
      end
    end
  end

  def reset_annotation_id_field
    if @rules.reset_annotation_id_field?
      @annotations.each_with_index do |annotation,count|
        annotation.id = sprintf("%06d",count+1)
      end
    end
  end

  def complement_reverse_strand_annotations
    @annotations.each{|i| i.reverse if i.negative_strand? }
  end

end
