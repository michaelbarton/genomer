Feature: Generating gff output
  In order to view and share genome annotations
  A user can generate the gff3 output format

  @announce
  Scenario: Generating a table file from a single annotation
    Given a file named "scaffold.yml" with:
      """
      ---
        - sequence:
            source: contig1
      """
    Given a file named "sequences.fna" with:
      """
      >contig1
      AAAAATTTTTGGGGGCCCCC
      """
    Given a file named "annotations.gff" with:
      """
      ##gff-version 3
      contig1	.	gene	1	3	.	+	1	.
      """
    Given a file named "Rules" with:
      """
      scaffold_file 'scaffold.yml'
      sequence_file 'sequences.fna'
      annotation_file 'annotations.gff'
      out_file_name 'genome'
      identifier 'genome'
      output :gff3
      """
    When I run `genomer Rules`
    Then the exit status should be 0
    And a file named "genome.gff" should exist
    And the file "genome.gff" should contain exactly:
    """
      ##gff-version 3
      scaffold	.	gene	1	3	.	+	1	.

    """
