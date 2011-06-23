class Genomer::OutputType::Table < Genomer::OutputType

  SUFFIX = 'tbl'

  def generate
    process
    render
  end

  def process
    link_cds_id_to_parent_gene_id
    filter_non_protein_annotations

    reset_id if @rules.reset_id
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

  def prefix_id(prefix)
    return unless prefix
    genes = annotations.select{|i| i.feature == 'gene'}
    genes.each{|attn| attn.id.insert(0,prefix) }
  end

  def reset_id
    genes = annotations.select{|i| i.feature == 'gene'}
    genes.each_with_index do |annotation,count|
      annotation.id.replace sprintf("%06d",count+1)
    end
  end

  def filter_non_protein_annotations
    annotations.reject! do |attn|
      ! (attn.feature == 'gene' || attn.feature == 'CDS')
    end
  end

  def link_cds_id_to_parent_gene_id
    annotations.select{|i| i.feature == 'CDS'}.each do |attn|
      attn.id = parent_gene(attn).id
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
