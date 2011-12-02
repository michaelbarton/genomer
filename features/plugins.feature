Feature: Using plugins as part of a genomer project
  In order to use third-party genomer plugins
  A user can specify genomer plugins in a Gemfile
  So that these plugins are available on the command line

  @disable-bundler
  Scenario: Running help with no genomer plugins specified
    Given I run the genomer command with the arguments "init project"
      And I cd to "project"
      And I append to "Gemfile" with ""
     When I run the genomer command with the arguments "help"
     Then the exit status should be 0
      And the output should contain:
     """
     genomer COMMAND [options]

     Available commands:
       init        Create a new genomer project
     """

  @disable-bundler
  Scenario: Running help with a single genomer plugins specified
    Given I run the genomer command with the arguments "init project"
      And I cd to "project"
      And I append to "Gemfile" with:
      """
      gem 'genomer-plugin-simple', :path => '../../../genomer-plugin-simple'
      """
     When I run the genomer command with the arguments "help"
     Then the exit status should be 0
      And the output should contain:
     """
     genomer COMMAND [options]

     Available commands:
       init        Create a new genomer project
       simple      Simple genomer plugin for testing purposes
     """

  @disable-bundler
  Scenario: Calling a non-specified genomer plugin
    Given I run the genomer command with the arguments "init project"
      And I cd to "project"
      And I append to "Gemfile" with ""
     When I run the genomer command with the arguments "simple"
     Then the exit status should be 1
      And the output should contain:
     """
     Error. Unknown command or plugin 'simple.'
     run `genomer help` for a list of available commands

     """

  @disable-bundler
  Scenario: Calling a genomer plugin with no command
    Given I run the genomer command with the arguments "init project"
      And I cd to "project"
      And I append to "Gemfile" with:
      """
      gem 'genomer-plugin-simple', :path => '../../../genomer-plugin-simple'
      """
     When I run the genomer command with the arguments "simple"
     Then the exit status should be 0
      And the output should contain:
     """
     Plugin "simple" called
     """

  @disable-bundler
  Scenario: Calling a genomer plugin with a command
    Given I run the genomer command with the arguments "init project"
      And I cd to "project"
      And I append to "Gemfile" with:
      """
      gem 'genomer-plugin-simple', :path => '../../../genomer-plugin-simple'
      """
     When I run the genomer command with the arguments "simple echo some words"
     Then the exit status should be 0
      And the output should contain:
     """
     Echo: some words
     """

  @disable-bundler
  Scenario: Plugin accessing the scaffold
    Given I run the genomer command with the arguments "init project"
      And I cd to "project"
      And I append to "Gemfile" with:
      """
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

