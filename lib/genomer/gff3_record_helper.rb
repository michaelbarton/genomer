require 'bio'

module Genomer::GffRecordHelper

  def negative_strand?
    self.strand == '-'
  end

  def reverse
    self.start, self.end = self.end, self.start
    self
  end

end
