require 'bio'

module Genomer::GffRecordHelper

  def negative_strand?
    self.strand == '-'
  end

end
