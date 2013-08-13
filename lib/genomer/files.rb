require 'genomer/version'

class Genomer::Files
  class << self

    def gemfile
      version = Genomer::VERSION.split('.')[0..1].<<(0).join('.')
      <<-EOF.unindent
        source "https://rubygems.org"

        gem 'genomer',    '~> #{version}'
      EOF
    end

    def scaffold_yml
      <<-EOF.unindent
        # Specify your genome scaffold in YAML format here. Reference nucleotide
        # sequences in the 'sequences.fna' file using the first space delimited
        # word of each fasta header.
        #
        # Go to http://next.gs/getting-started/ to start writing genome scaffold
        # files.
        #
        # A simple one contig example is also provided below. Delete this as you
        # start writing your own scaffold.
        ---
          -
            sequence:
              source: "contig1"
      EOF
    end

    def sequence_fna
      <<-EOF.unindent
        ; Add your assembled contigs and scaffolds sequences to this file.
        ; These sequences can be referenced in the 'scaffold.yml' file
        ; using the first space delimited word in each fasta header.
        > contig1
        ATGC
      EOF
    end

    def annotations_gff
      <<-EOF.unindent
      ##gff-version   3
      ## Add your gff3 formatted annotations to this file
      EOF
    end

  end
end
