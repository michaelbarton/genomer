Feature: Generating fasta output
  In order to generate a genome in fasta format
  A user can use the fasta output option

  Scenario: Generating a simple fasta file
    Given a file named "scaffold.yml" with:
      """
      ---
        - sequence:
            source: contig1
      """
    Given a file named "sequences.fna" with:
      """
      >contig1
      ATG
      """
    Given a file named "Rules" with:
      """
      scaffold_file 'scaffold.yml'
      sequence_file 'sequences.fna'
      out_file_name 'genome'
      output :fasta
      """
    When I run `genomer Rules`
    Then the exit status should be 0
    And a file named "genome.fsa" should exist
    And the file "genome.fsa" should contain exactly:
    """
    >.
    ATG

    """

  Scenario: Generating a fasta file with an identifier
    Given a file named "scaffold.yml" with:
      """
      ---
        - sequence:
            source: contig1
      """
    Given a file named "sequences.fna" with:
      """
      >contig1
      ATG
      """
    Given a file named "Rules" with:
      """
      scaffold_file 'scaffold.yml'
      sequence_file 'sequences.fna'
      out_file_name 'genome'
      identifier 'something'
      output :fasta
      """
    When I run `genomer Rules`
    Then the exit status should be 0
    And a file named "genome.fsa" should exist
    And the file "genome.fsa" should contain exactly:
    """
    >something
    ATG

    """

  Scenario: Generating a fasta file with metadata
    Given a file named "scaffold.yml" with:
      """
      ---
        - sequence:
            source: contig1
      """
    Given a file named "sequences.fna" with:
      """
      >contig1
      ATG
      """
    Given a file named "Rules" with:
      """
      scaffold_file 'scaffold.yml'
      sequence_file 'sequences.fna'
      out_file_name 'genome'
      metadata 'organism' => 'something'
      output :fasta
      """
    When I run `genomer Rules`
    Then the exit status should be 0
    And a file named "genome.fsa" should exist
    And the file "genome.fsa" should contain exactly:
    """
    >. [organism=something]
    ATG

    """

  Scenario: Generating a fasta file with metadata and identifier
    Given a file named "scaffold.yml" with:
      """
      ---
        - sequence:
            source: contig1
      """
    Given a file named "sequences.fna" with:
      """
      >contig1
      ATG
      """
    Given a file named "Rules" with:
      """
      scaffold_file 'scaffold.yml'
      sequence_file 'sequences.fna'
      out_file_name 'genome'
      identifier 'genome1'
      metadata 'organism' => 'something'
      output :fasta
      """
    When I run `genomer Rules`
    Then the exit status should be 0
    And a file named "genome.fsa" should exist
    And the file "genome.fsa" should contain exactly:
    """
    >genome1 [organism=something]
    ATG

    """
