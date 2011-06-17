class Genomer::OutputType::Table < Genomer::OutputType
  SUFFIX = 'tbl'

  ID_FIELD  = 'locus_tag'

  def generate

    updated = annotations
    if @rules.reset_annotation_id_field?
      updated = self.class.reset_id(updated,@rules.annotation_id_field)
    end

    render updated
  end

  private

  def render(annotations)
    delimiter = "\t"
    indent    = delimiter * 2

    out = Array.new
    out << %W|>Feature #{identifier} annotation_table|
    annotations.each do |annotation|
      out << strand(annotation)
      annotation.attributes.each{|attr| out << remap(attr).unshift(indent)}
    end
    out.map{|line| line * delimiter} * "\n" + "\n"
  end

  def strand(annotation)
    if annotation.strand == '+'
      [annotation.start,annotation.end,annotation.feature]
    else
      [annotation.end,annotation.start,annotation.feature]
    end
  end

  def remap(attr)
    if @rules.map_annotations and @rules.map_annotations[attr.first]
      attr = [@rules.map_annotations[attr.first],attr.last]
    end
    if @rules.annotation_id_field == attr.first
      attr = [ID_FIELD,@rules.annotation_id_field_prefix.to_s + attr.last]
    end
    attr
  end

  def self.reset_id(records,id)
    records.sort!{|a,b| a.start <=> b.start }.each_with_index do |record,count|
      index = record.attributes.index{|a| a.first == id}
      record.attributes[index][1]= sprintf("%06d",count+1)
    end
    records
  end

end
