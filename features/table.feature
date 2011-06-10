Feature: Generating annotation table output
  In order to submit genome annotations
  A user can generate the genbank annotation table format

  Scenario: Generating a simple table file
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
    Given a file named "annotations.gff" with:
      """
      ##gff-version 3
      contig1	.	CDS	1	3	.	+	1	ID=gene1
      """
    Given a file named "Rules" with:
      """
      scaffold_file 'scaffold.yml'
      sequence_file 'sequences.fna'
      sequence_file 'annotations.gff'
      out_file_name 'genome'
      output :table
      """
    When I run `genomer Rules`
    Then the exit status should be 0
    And a file named "genome.tbl" should exist
    And the file "genome.tbl" should contain exactly:
    """
    >Feature pflr124 annotations
    1	3	CDS
    			product	gene1
    """
