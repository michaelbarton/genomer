class Genomer::OutputType::Table < Genomer::OutputType
  SUFFIX = 'tbl'

  ID_FIELD  = 'locus_tag'

  def generate
    reset_annotation_id_field
    prefix_annotation_id_field

    complement_reverse_strand_annotations

    render @annotations
  end

  private

  def prefix_annotation_id_field
    if @rules.annotation_id_field_prefix
      @annotations.each do |annotation|
        annotation.id = @rules.annotation_id_field_prefix + annotation.id
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

  def render(annotations)
    delimiter = "\t"
    indent    = delimiter * 2

    out = Array.new
    out << %W|>Feature #{identifier} annotation_table|
    annotations.each do |annotation|
      out << [annotation.start,annotation.end,annotation.feature]
      annotation.attributes.each do |attr|
        if attr.first == 'ID'
          out << [indent,ID_FIELD,attr.last]
        else
          out << attr.unshift(indent)
        end
      end
    end
    out.map{|line| line * delimiter} * "\n" + "\n"
  end

end
