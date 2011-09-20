Feature: Using plugins as part of a genomer project
  In order to use third-party genomer plugins
  A user can specify genomer plugins in a Gemfile
  So that these plugins are available on the command line

  Background:
    Given I have installed the gem "genomer-plugin-fake"

  Scenario: Genomer plugins described in the gem file
    Given I run the genomer command with the arguments "init project"
      And I cd to "project"
      And I append to "Gemfile" with "gem 'genomer-plugin-fake'"
     When I run the genomer command with the arguments "help"
     Then the output should contain:
     """
     genomer COMMAND [options]

     Available commands:
       fake       Fake genomer plugin for testing purposes
     """

  Scenario: Genomer plugins described in the gem file
    Given I run the genomer command with the arguments "init project"
      And I cd to "project"
      And I append to "Gemfile" with ""
     When I run the genomer command with the arguments "help"
     Then the output should contain:
     """
     genomer COMMAND [options]

     Available commands:
     """
