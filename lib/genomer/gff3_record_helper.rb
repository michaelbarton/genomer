require 'bio'

module Genomer::GffRecordHelper

  def negative_strand?
    self.strand == '-'
  end

  def to_genbank_feature_row
    out = [coordinates]
    attributes.each do |atr|
      out << process(atr) unless atr.first == 'Parent'
    end
    out
  end

  def coordinates
    if negative_strand?
      [self.end,self.start,self.feature]
    else
      [self.start,self.end,self.feature]
    end
  end

  def process(attr)
    return attr unless attr.first == 'ID'
    case feature
    when 'gene' then ['locus_tag', attr.last]
    when 'CDS'  then ['protein_id',"gnl|ncbi|" + attr.last]
    end
  end

end
