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
    attributes.each{|atr| out << atr}
    out
  end

end
