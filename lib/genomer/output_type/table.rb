class Genomer::OutputType::Table < Genomer::OutputType

  SUFFIX = 'tbl'

  def generate
    process
    render
  end

  def process
    link_cds_id_to_parent_gene_id
    filter_non_protein_annotations

    reset_id if @rules.reset_id?
    prefix_id @rules.id_prefix
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

end
