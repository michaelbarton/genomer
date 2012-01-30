Feature: Plugins accessing annotations in a genomer project
  In order to access gff annotations in a genomer plugin
  A plugin developer can access annotations from the #annotations method
  So that these annotations are available for use

  @disable-bundler
  Scenario: Two annotations on a single contig
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
        contig1	.	gene	1	3	.	+	1	.
        contig1	.	gene	5	7	.	+	1	.
        """
     When I run the genomer command with the arguments "simple annotations"
     Then the exit status should be 0
      And the output should contain:
        """
        ##gff-version 3
        scaffold	.	gene	1	3	.	+	1	.
        scaffold	.	gene	5	7	.	+	1	.
        """

  @disable-bundler
  Scenario: Two annotations on a two contigs
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
        -
          sequence:
            source: contig2

        """
      And I append to "assembly/sequence.fna" with:
        """
        >contig1
        ATGCATGC
        >contig2
        ATGCATGC
        """
      And I append to "assembly/annotations.gff" with:
        """
        ##gff-version 3
        contig1	.	gene	1	3	.	+	1	.
        contig2	.	gene	5	7	.	+	1	.
        """
     When I run the genomer command with the arguments "simple annotations"
     Then the exit status should be 0
      And the output should contain:
        """
        ##gff-version 3
        scaffold	.	gene	1	3	.	+	1	.
        scaffold	.	gene	13	15	.	+	1	.
        """

  @disable-bundler
  Scenario: Two annotations on a single contig with an unused annotation
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
        contig2	.	gene	5	7	.	+	1	.
        contig1	.	gene	1	3	.	+	1	.
        contig1	.	gene	5	7	.	+	1	.
        """
     When I run the genomer command with the arguments "simple annotations"
     Then the exit status should be 0
      And the output should contain:
        """
        ##gff-version 3
        scaffold	.	gene	1	3	.	+	1	.
        scaffold	.	gene	5	7	.	+	1	.
        """

  @disable-bundler
  Scenario: Three unordered annotations on a single contig
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
        ATGCATGCATGC
        """
      And I append to "assembly/annotations.gff" with:
        """
        ##gff-version 3
        contig1	.	gene	9	11	.	+	1	.
        contig1	.	gene	1	3	.	+	1	.
        contig1	.	gene	5	7	.	+	1	.
        """
     When I run the genomer command with the arguments "simple annotations"
     Then the exit status should be 0
      And the output should contain:
        """
        ##gff-version 3
        scaffold	.	gene	1	3	.	+	1	.
        scaffold	.	gene	5	7	.	+	1	.
        scaffold	.	gene	9	11	.	+	1	.
        """

  @disable-bundler
  Scenario: Four unordered annotations on a two contigs
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
        -
          sequence:
            source: contig2

        """
      And I append to "assembly/sequence.fna" with:
        """
        >contig1
        ATGCATGC
        >contig2
        ATGCATGC
        """
      And I append to "assembly/annotations.gff" with:
        """
        ##gff-version 3
        contig2	.	gene	5	7	.	+	1	.
        contig2	.	gene	1	3	.	+	1	.
        contig1	.	gene	1	3	.	+	1	.
        contig1	.	gene	5	7	.	+	1	.
        """
     When I run the genomer command with the arguments "simple annotations"
     Then the exit status should be 0
      And the output should contain:
        """
        ##gff-version 3
        scaffold	.	gene	1	3	.	+	1	.
        scaffold	.	gene	5	7	.	+	1	.
        scaffold	.	gene	9	11	.	+	1	.
        scaffold	.	gene	13	15	.	+	1	.

        """

  @disable-bundler
  Scenario: Annotations on reversed and trimmed contigs with inserts
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
          - sequence:
              source: contig1
              stop: 6
          - sequence:
              source: contig2
              reverse: true
              inserts:
              -
                source: insert1
                open: 6
                close: 7
          - sequence:
              source: contig3
              start: 3

        """
      And I append to "assembly/sequence.fna" with:
        """
        > contig1
        AAAAAGGG
        > contig2
        AAAAAGGGGGC
        > contig3
        AAAAAGGG
        > insert1
        TTT
        """
      And I append to "assembly/annotations.gff" with:
        """
        ##gff-version 3
        contig1	.	gene	1	4	.	+	1	ID=gene1
        contig1	.	gene	5	8	.	+	1	ID=gene2
        contig2	.	gene	1	4	.	+	1	ID=gene3
        contig2	.	gene	8	11	.	+	1	ID=gene4
        contig3	.	gene	1	3	.	+	1	ID=gene5
        contig3	.	gene	4	8	.	+	1	ID=gene6

        """
     When I run the genomer command with the arguments "simple annotations"
     Then the exit status should be 0
      And the output should contain:
        """
        ##gff-version 3
        scaffold	.	gene	1	4	.	+	1	ID=gene1
        scaffold	.	gene	7	10	.	-	1	ID=gene4
        scaffold	.	gene	15	18	.	-	1	ID=gene3
        scaffold	.	gene	20	24	.	+	1	ID=gene6

        """

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
