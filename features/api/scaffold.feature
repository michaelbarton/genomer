Feature: Plugins accessing the scaffold in a genomer project
  In order to access the scaffold in a genomer plugin
  A plugin developer can access the scaffold using the #scaffold method
  So that the scaffold can be used

  @disable-bundler
  Scenario: Plugin accessing the scaffold
    Given I run the genomer command with the arguments "init project"
      And I cd to "project"
      And I overwrite "Gemfile" with:
      """
      gem 'genomer',               :path => '../../../'
      gem 'genomer-plugin-simple', :path => '../../../genomer-plugin-simple'
      """
      And I overwrite "assembly/scaffold.yml" with:
      """
      ---
      -
        sequence:
          source: contig1
      -
        sequence:
          source: contig2

      """
      And I overwrite "assembly/sequence.fna" with:
      """
      >contig1
      ATGC
      >contig2
      ATGC
      """
     When I run the genomer command with the arguments "simple describe"
     Then the exit status should be 0
      And the output should contain:
     """
     The scaffold contains 2 entries
     """
