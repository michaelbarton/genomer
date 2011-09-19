Feature: Using plugins as part of a genomer project
  In order to use third-party genomer plugins
  A user can specify genomer plugins in a Gemfile
  So that these plugins are available on the command line

  Background:
    Given I have installed the gem "genomer-plugin-fake"

  Scenario: Adding a genomer plugin
    Given I run the genomer command with the arguments "init project"
      And I cd to "project"
      And I append to "Gemfile" with "gem 'genomer-plugin-fake'"
     When I run the genomer command with the arguments "help"
     Then the output should contain:
     """
     fake       Fake genomer plugin for testing purposes
     """
