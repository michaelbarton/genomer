Feature: Creating a genomer project
  In order to build a genome
  A user can create a genomer project
  So that they can use the genomer commands and organise their data

  Scenario: Creating a new project
    When I run the genomer command with the arguments "init project"
    Then the exit status should be 0
    And a directory named "project" should exist

  Scenario: Creating a new project where the directory already exists
    Given a directory named "project"
    When I run the genomer command with the arguments "init project"
    Then the exit status should be 1
    And the stderr should contain:
    """
    Error. Directory 'project' already exists.
    """
