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
