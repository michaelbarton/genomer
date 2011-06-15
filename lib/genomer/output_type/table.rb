class Genomer::OutputType::Table < Genomer::OutputType
  SUFFIX = 'tbl'

  DELIMITER = "\t"
  INDENT    = DELIMITER * 2

  ID_FIELD  = 'locus_tag'

  def generate
    out = Array.new
    out << %W|>Feature #{@rules.identifier} annotation_table|
    annotations.each do |annotation|
      out << strand(annotation)
      annotation.attributes.each{|attr| out << remap(attr).unshift(INDENT)}
    end
    out.map{|line| line * DELIMITER} * "\n" + "\n"
  end

  private

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
      attr = [ID_FIELD,attr.last]
    end
    attr
  end

end
