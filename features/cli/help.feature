Feature: Listing available commands
  In order to know which commands are available
  A user can use the help command
  To list the available options to the console

  Scenario: Running genomer with no commands
     When I run the genomer command with no arguments
     Then the exit status should be 0
      And the output should contain:
     """
     genomer COMMAND [options]
     run `genomer help` for a list of available commands

     """

  Scenario: Running genomer with the help command
     When I run the genomer command with the arguments "help"
     Then the exit status should be 0
      And the output should contain:
     """
     genomer COMMAND [options]

     Available commands:
     """
      And the output should contain:
     """
       init        Create a new genomer project
     """
      And the output should contain:
     """
       man         View man page for the specified plugin
     """

  Scenario: Running genomer with the --version flag
     When I run the genomer command with the arguments "--version"
     Then the exit status should be 0
      And the output should match:
     """
     Genomer version \d+.\d+.\d+
     """

  @disable-bundler
  Scenario: Running help with a single genomer plugins specified
    Given I run the genomer command with the arguments "init project"
      And I cd to "project"
      And I overwrite "Gemfile" with:
      """
      gem 'genomer-plugin-simple', :path => '../../../genomer-plugin-simple'
      """
     When I run the genomer command with the arguments "help"
     Then the exit status should be 0
      And the output should contain:
     """
       simple      Simple genomer plugin for testing purposes
     """

