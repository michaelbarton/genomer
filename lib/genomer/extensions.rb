require 'genomer/gff3_record_helper'

Bio::GFF::GFF3::Record.send(:include, Genomer::GffRecordHelper)
