Feature: Using plugins as part of a genomer project
  In order to use third-party genomer plugins
  A user can specify genomer plugins in a Gemfile
  So that these plugins are available on the command line

  Background:
    Given I have installed the gem "genomer-plugin-fake"

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
     """

  @disable-bundler
  Scenario: Running help with a single genomer plugins specified
    Given I run the genomer command with the arguments "init project"
      And I cd to "project"
      And I append to "Gemfile" with "gem 'genomer-plugin-fake'"
     When I run the genomer command with the arguments "help"
     Then the exit status should be 0
      And the output should contain:
     """
     genomer COMMAND [options]

     Available commands:
       fake        Fake genomer plugin for testing purposes
     """

  @disable-bundler
  Scenario: Calling a specified genomer plugin using a command
    Given I run the genomer command with the arguments "init project"
      And I cd to "project"
      And I append to "Gemfile" with "gem 'genomer-plugin-fake'"
     When I run the genomer command with the arguments "fake"
     Then the exit status should be 0
      And the output should contain:
     """
     Plugin "fake" called
     """
