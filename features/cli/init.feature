Feature: Creating a new genomer project
  In order to build a genome
  A user can create a new genomer project
  So that they can use the genomer commands and organise their data

  Scenario: Creating a new project
    When I run the genomer command with the arguments "init project"
    Then the exit status should be 0
    And a directory named "project" should exist
    And a directory named "project/assembly" should exist
    And a file named "project/assembly/scaffold.yml" should exist
    And the file "project/assembly/scaffold.yml" should contain exactly:
    """
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
      - sequence:
        source: contig1

    """
    And a file named "project/assembly/sequence.fna" should exist
    And the file "project/assembly/sequence.fna" should contain exactly:
    """
    ; Add your assembled contigs and scaffolds sequences to this file.
    ; These sequences can be referenced in the 'scaffold.yml' file
    ; using the first space delimited word in each fasta header.
    > contig1
    ATGC

    """
    And a file named "project/assembly/annotations.gff" should exist
    And the file "project/assembly/annotations.gff" should contain exactly:
    """
    ##gff-version   3
    ## Add your gff3 formatted annotations to this file

    """
    And a file named "project/Gemfile" should exist

  Scenario: Creating a new project where the directory already exists
    Given a directory named "project"
    When I run the genomer command with the arguments "init project"
    Then the exit status should be 1
    And the stderr should contain:
    """
    Error. Directory 'project' already exists.
    """
