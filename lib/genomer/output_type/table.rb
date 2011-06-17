class Genomer::OutputType::Table < Genomer::OutputType
  SUFFIX = 'tbl'

  ID_FIELD  = 'locus_tag'

  def generate
    remap_annotation_fields
    reset_annotation_id_field
    prefix_annotation_id_field

    complement_reverse_strand_annotations

    render @annotations
  end

  private

  def prefix_annotation_id_field
    @annotations.each do |annotation|
      annotation.attributes.map! do |attr|
        if @rules.annotation_id_field == attr.first
          [ID_FIELD,@rules.annotation_id_field_prefix.to_s + attr.last]
        else
          attr
        end
      end
    end
  end

  def remap_annotation_fields
    if @rules.map_annotations
      @annotations.each do |annotation|
        annotation.attributes.map! do |attr|
          if @rules.map_annotations[attr.first]
            attr = [@rules.map_annotations[attr.first],attr.last]
          else
            attr
          end
        end
      end
    end
  end

  def reset_annotation_id_field
    if @rules.reset_annotation_id_field?
      self.class.reset_id(@annotations,@rules.annotation_id_field)
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
      annotation.attributes.each{|attr| out << attr.unshift(indent)}
    end
    out.map{|line| line * delimiter} * "\n" + "\n"
  end

  def self.reset_id(records,id)
    records.sort!{|a,b| a.start <=> b.start }.each_with_index do |record,count|
      index = record.attributes.index{|a| a.first == id}
      record.attributes[index][1]= sprintf("%06d",count+1)
    end
    records
  end

end
