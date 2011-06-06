Feature: Generating genbank output
  In order to generate a genome in genbank format
  A user can use the genbank output option

  Scenario: Generating a simple genbank file
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
      output :genbank
      """
    When I run `genomer Rules`
    Then the exit status should be 0
    And a file named "genome.gb" should exist
    And the file "genome.gb" should contain exactly:
    """
    LOCUS                                  3 bp    NA                   0000-01-01
    DEFINITION  .
    ACCESSION   
    VERSION     .
    KEYWORDS    .
    SOURCE      
      ORGANISM  
                .
    FEATURES             Location/Qualifiers
    ORIGIN
            1 ATG
    //

    """

  Scenario: Setting the LOCUS metadata
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
      output :genbank
      """
    When I run `genomer Rules`
    Then the exit status should be 0
    And a file named "genome.gb" should exist
    And the file "genome.gb" should match /LOCUS\s+something/

  Scenario: Setting the DEFINITION metadata
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
      description 'something'
      output :genbank
      """
    When I run `genomer Rules`
    Then the exit status should be 0
    And a file named "genome.gb" should exist
    And the file "genome.gb" should match /DEFINITION\s+something/
