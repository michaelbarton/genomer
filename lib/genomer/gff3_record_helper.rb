require 'bio'

module Genomer::GffRecordHelper

  def negative_strand?
    self.strand == '-'
  end

  def to_genbank_feature_row
    if negative_strand?
      [self.end,self.start,self.feature]
    else
      [self.start,self.end,self.feature]
    end
  end

end
