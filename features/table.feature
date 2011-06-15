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

  Scenario: Mapping gff attribute fields to table fields
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
      map_annotations 'ID' => 'locus_tag'
      """
    When I run `genomer Rules`
    Then the exit status should be 0
    And a file named "genome.tbl" should exist
    And the file "genome.tbl" should contain exactly:
    """
    >Feature	genome	annotation_table
    3	1	CDS
    			locus_tag	gene1

    """

  Scenario: Specifying the gene ID field
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
      annotation_id_field 'ID'
      """
    When I run `genomer Rules`
    Then the exit status should be 0
    And a file named "genome.tbl" should exist
    And the file "genome.tbl" should contain exactly:
    """
    >Feature	genome	annotation_table
    3	1	CDS
    			locus_tag	gene1

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
      contig1	.	CDS	1	3	.	+	1	ID=gene1
      contig1	.	CDS	4	6	.	+	1	ID=gene2
      """
    Given a file named "Rules" with:
      """
      scaffold_file 'scaffold.yml'
      sequence_file 'sequences.fna'
      annotation_file 'annotations.gff'
      out_file_name 'genome'
      identifier 'genome'
      output :table
      annotation_id_field 'ID'
      reset_annotation_id_field
      """
    When I run `genomer Rules`
    Then the exit status should be 0
    And a file named "genome.tbl" should exist
    And the file "genome.tbl" should contain exactly:
    """
    >Feature	genome	annotation_table
    1	3	CDS
    			locus_tag	000001
    4	6	CDS
    			locus_tag	000002

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
      contig1	.	CDS	10	12	.	+	1	ID=gene4
      contig1	.	CDS	4	6	.	+	1	ID=gene2
      contig1	.	CDS	1	3	.	+	1	ID=gene1
      contig1	.	CDS	7	9	.	+	1	ID=gene3
      """
    Given a file named "Rules" with:
      """
      scaffold_file 'scaffold.yml'
      sequence_file 'sequences.fna'
      annotation_file 'annotations.gff'
      out_file_name 'genome'
      identifier 'genome'
      output :table
      annotation_id_field 'ID'
      reset_annotation_id_field
      """
    When I run `genomer Rules`
    Then the exit status should be 0
    And a file named "genome.tbl" should exist
    And the file "genome.tbl" should contain exactly:
    """
    >Feature	genome	annotation_table
    1	3	CDS
    			locus_tag	000001
    4	6	CDS
    			locus_tag	000002
    7	9	CDS
    			locus_tag	000003
    10	12	CDS
    			locus_tag	000004

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
      contig1	.	CDS	1	3	.	+	1	ID=gene1
      contig1	.	CDS	4	6	.	+	1	ID=gene2
      """
    Given a file named "Rules" with:
      """
      scaffold_file 'scaffold.yml'
      sequence_file 'sequences.fna'
      annotation_file 'annotations.gff'
      out_file_name 'genome'
      identifier 'genome'
      output :table
      annotation_id_field 'ID'
      annotation_id_field_prefix 'S_'
      """
    When I run `genomer Rules`
    Then the exit status should be 0
    And a file named "genome.tbl" should exist
    And the file "genome.tbl" should contain exactly:
    """
    >Feature	genome	annotation_table
    1	3	CDS
    			locus_tag	S_gene1
    4	6	CDS
    			locus_tag	S_gene2

    """
