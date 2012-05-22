Feature: Changing annotation IDs
  In order to tailor annotation IDs to specific genomes
  A plugin developer can pass options to the #annotations method
  So that the annotation IDs are correspondingly changed

  @disable-bundler
  Scenario: Adding a prefix to annotation IDs
    Given I run the genomer command with the arguments "init project"
      And I cd to "project"
      And I append to "Gemfile" with:
        """
        gem 'genomer',               :path => '../../../'
        gem 'genomer-plugin-simple', :path => '../../../genomer-plugin-simple'
        """
      And I append to "assembly/scaffold.yml" with:
        """
        ---
        -
          sequence:
            source: contig1

        """
      And I append to "assembly/sequence.fna" with:
        """
        >contig1
        ATGCATGC
        """
      And I append to "assembly/annotations.gff" with:
        """
        ##gff-version 3
        contig1	.	gene	1	4	.	+	1	ID=gene1
        contig1	.	gene	5	8	.	+	1	ID=gene2
        """
     When I run the genomer command with the arguments "simple annotations --prefix=pre_"
     Then the exit status should be 0
      And the output should contain:
        """
        ##gff-version 3
        scaffold	.	gene	1	4	.	+	1	ID=pre_gene1
        scaffold	.	gene	5	8	.	+	1	ID=pre_gene2
        """

  @disable-bundler
  Scenario: Reseting locus tag numbering from the sequence start
    Given I run the genomer command with the arguments "init project"
      And I cd to "project"
      And I append to "Gemfile" with:
        """
        gem 'genomer',               :path => '../../../'
        gem 'genomer-plugin-simple', :path => '../../../genomer-plugin-simple'
        """
      And I append to "assembly/scaffold.yml" with:
        """
        ---
        -
          sequence:
            source: contig1

        """
      And I append to "assembly/sequence.fna" with:
        """
        >contig1
        ATGCATGC
        """
      And I append to "assembly/annotations.gff" with:
        """
        ##gff-version 3
        contig1	.	gene	1	4	.	+	1	ID=gene1
        contig1	.	gene	5	8	.	+	1	ID=gene2
        """
     When I run the genomer command with the arguments "simple annotations --reset_locus_numbering"
     Then the exit status should be 0
      And the output should contain:
        """
        ##gff-version 3
        scaffold	.	gene	1	4	.	+	1	ID=000001
        scaffold	.	gene	5	8	.	+	1	ID=000002
        """

  @disable-bundler
  Scenario: Reseting locus tag numbering and adding a prefix
    Given I run the genomer command with the arguments "init project"
      And I cd to "project"
      And I append to "Gemfile" with:
        """
        gem 'genomer',               :path => '../../../'
        gem 'genomer-plugin-simple', :path => '../../../genomer-plugin-simple'
        """
      And I append to "assembly/scaffold.yml" with:
        """
        ---
        -
          sequence:
            source: contig1

        """
      And I append to "assembly/sequence.fna" with:
        """
        >contig1
        ATGCATGC
        """
      And I append to "assembly/annotations.gff" with:
        """
        ##gff-version 3
        contig1	.	gene	1	4	.	+	1	ID=gene1
        contig1	.	gene	5	8	.	+	1	ID=gene2
        """
      When I run the genomer command with the arguments "simple annotations --reset_locus_numbering --prefix=pre_"
     Then the exit status should be 0
      And the output should contain:
        """
        ##gff-version 3
        scaffold	.	gene	1	4	.	+	1	ID=pre_000001
        scaffold	.	gene	5	8	.	+	1	ID=pre_000002
        """
