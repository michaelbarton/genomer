class Genomer::OutputType::Table < Genomer::OutputType
  SUFFIX = 'tbl'

  DELIMITER = "\t"
  INDENT    = DELIMITER * 2

  def generate
    out = Array.new
    out << %W|>Feature #{@rules.identifier} annotation_table|
    annotations.each do |annotation|
      out << map_annotation(annotation)
      annotation.attributes.each{|attr| out << attr.unshift(INDENT)}
    end
    out.map{|line| line * DELIMITER} * "\n" + "\n"
  end

  def map_annotation(annotation)
    if annotation.strand == '+'
      [annotation.start,annotation.end,annotation.feature]
    else
      [annotation.end,annotation.start,annotation.feature]
    end
  end


end
