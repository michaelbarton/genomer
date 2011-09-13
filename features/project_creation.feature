Feature: Creating a genomer project
  In order to build a genome
  A user can create a genomer project
  So that they can use the genomer commands and organise their data

  Scenario: Using the genomer command to create a project
    Given I run the genomer command with the arguments "create project"
    Then a directory named "project" should exist
