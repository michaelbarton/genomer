Feature: Generating gff output
  In order to view and share genome annotations
  A user can generate the gff3 output format

  Scenario: Generating a gff file from a single annotation
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

  Scenario: Generating a gff file from a single reversed annotation
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
      contig1	.	gene	1	3	.	-	1	.
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
      scaffold	.	gene	1	3	.	-	1	.

      """

  Scenario: Reset the gene id numbering at origin
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
      contig1	.	gene	1	3	.	+	1	ID=gene1
      contig1	.	gene	4	6	.	+	1	ID=gene2
      """
    Given a file named "Rules" with:
      """
      scaffold_file 'scaffold.yml'
      sequence_file 'sequences.fna'
      annotation_file 'annotations.gff'
      out_file_name 'genome'
      identifier 'genome'
      output :gff3
      reset_id
      """
    When I run `genomer Rules`
    Then the exit status should be 0
    And a file named "genome.gff" should exist
    And the file "genome.gff" should contain exactly:
      """
      ##gff-version 3
      scaffold	.	gene	1	3	.	+	1	ID=000001
      scaffold	.	gene	4	6	.	+	1	ID=000002

      """

  Scenario: Reset the gene id numbering at origin with unordered annotations
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
      contig1	.	gene	10	12	.	+	1	ID=gene4
      contig1	.	gene	4	6	.	+	1	ID=gene2
      contig1	.	gene	1	3	.	+	1	ID=gene1
      contig1	.	gene	7	9	.	+	1	ID=gene3
      """
    Given a file named "Rules" with:
      """
      scaffold_file 'scaffold.yml'
      sequence_file 'sequences.fna'
      annotation_file 'annotations.gff'
      out_file_name 'genome'
      identifier 'genome'
      output :gff3
      reset_id
      """
    When I run `genomer Rules`
    Then the exit status should be 0
    And a file named "genome.gff" should exist
    And the file "genome.gff" should contain exactly:
      """
      ##gff-version 3
      scaffold	.	gene	1	3	.	+	1	ID=000001
      scaffold	.	gene	4	6	.	+	1	ID=000002
      scaffold	.	gene	7	9	.	+	1	ID=000003
      scaffold	.	gene	10	12	.	+	1	ID=000004

      """

  Scenario: Adding a prefix to the annotation id
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
      contig1	.	gene	1	3	.	+	1	ID=gene1
      contig1	.	gene	4	6	.	+	1	ID=gene2
      """
    Given a file named "Rules" with:
      """
      scaffold_file 'scaffold.yml'
      sequence_file 'sequences.fna'
      annotation_file 'annotations.gff'
      out_file_name 'genome'
      identifier 'genome'
      output :gff3
      id_prefix 'S_'
      """
    When I run `genomer Rules`
    Then the exit status should be 0
    And a file named "genome.gff" should exist
    And the file "genome.gff" should contain exactly:
      """
      ##gff-version 3
      scaffold	.	gene	1	3	.	+	1	ID=S_gene1
      scaffold	.	gene	4	6	.	+	1	ID=S_gene2

      """

  Scenario: Adding a prefix and reseting the annotation ID
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
      contig1	.	gene	1	3	.	+	1	ID=gene1
      contig1	.	gene	4	6	.	+	1	ID=gene2
      """
    Given a file named "Rules" with:
      """
      scaffold_file 'scaffold.yml'
      sequence_file 'sequences.fna'
      annotation_file 'annotations.gff'
      out_file_name 'genome'
      identifier 'genome'
      output :gff3
      id_prefix 'S_'
      reset_id
      """
    When I run `genomer Rules`
    Then the exit status should be 0
    And a file named "genome.gff" should exist
    And the file "genome.gff" should contain exactly:
      """
      ##gff-version 3
      scaffold	.	gene	1	3	.	+	1	ID=S_000001
      scaffold	.	gene	4	6	.	+	1	ID=S_000002

      """
