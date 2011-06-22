require 'bio'

module Genomer::GffRecordHelper

  def negative_strand?
    self.strand == '-'
  end

  def to_genbank_feature_row
    out = Array.new
    if negative_strand?
      out << [self.end,self.start,self.feature]
    else
      out << [self.start,self.end,self.feature]
    end
    attributes.each{|atr| out << rowise(atr)}
    out
  end

  def rowise(attr)
    attr.first == 'ID' ? ['locus_tag',attr.last] : attr
  end

end
