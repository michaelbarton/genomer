Feature: The Rules file
  In order to create repeatable genome builds
  A user can specify the output in a Rules file

  Scenario: Parsing an empty Rules file
    Given an empty Rules file
    When the genomer executable is invoked
    Then genomer should exit without any error
