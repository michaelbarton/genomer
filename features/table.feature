Feature: Generating annotation table output
  In order to submit genome annotations
  A user can generate the genbank annotation table format

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
      contig1	.	CDS	1	3	.	+	1	.
      """
    Given a file named "Rules" with:
      """
      scaffold_file 'scaffold.yml'
      sequence_file 'sequences.fna'
      annotation_file 'annotations.gff'
      out_file_name 'genome'
      identifier 'genome'
      output :table
      """
    When I run `genomer Rules`
    Then the exit status should be 0
    And a file named "genome.tbl" should exist
    And the file "genome.tbl" should contain exactly:
    """
    >Feature	genome	annotation_table
    1	3	CDS

    """

  Scenario: Generating a table file from a single reversed annotation
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
      contig1	.	CDS	1	3	.	-	1	.
      """
    Given a file named "Rules" with:
      """
      scaffold_file 'scaffold.yml'
      sequence_file 'sequences.fna'
      annotation_file 'annotations.gff'
      out_file_name 'genome'
      identifier 'genome'
      output :table
      """
    When I run `genomer Rules`
    Then the exit status should be 0
    And a file named "genome.tbl" should exist
    And the file "genome.tbl" should contain exactly:
    """
    >Feature	genome	annotation_table
    3	1	CDS

    """

  Scenario: Generating a table file from an annotation with attributes
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
      contig1	.	CDS	1	3	.	-	1	ID=gene1
      """
    Given a file named "Rules" with:
      """
      scaffold_file 'scaffold.yml'
      sequence_file 'sequences.fna'
      annotation_file 'annotations.gff'
      out_file_name 'genome'
      identifier 'genome'
      output :table
      """
    When I run `genomer Rules`
    Then the exit status should be 0
    And a file named "genome.tbl" should exist
    And the file "genome.tbl" should contain exactly:
    """
    >Feature	genome	annotation_table
    3	1	CDS
    			ID	gene1

    """

  Scenario: Generating a table file from two attributes
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
      contig1	.	CDS	1	3	.	+	1	
      contig1	.	CDS	4	6	.	+	1	
      """
    Given a file named "Rules" with:
      """
      scaffold_file 'scaffold.yml'
      sequence_file 'sequences.fna'
      annotation_file 'annotations.gff'
      out_file_name 'genome'
      identifier 'genome'
      output :table
      """
    When I run `genomer Rules`
    Then the exit status should be 0
    And a file named "genome.tbl" should exist
    And the file "genome.tbl" should contain exactly:
    """
    >Feature	genome	annotation_table
    1	3	CDS
    4	6	CDS

    """
