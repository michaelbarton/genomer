Feature: Reporting genomer errors
  In order to use genomer correctly
  A user can see descriptive genomer error messages
  And understand how to correct the errors

  Scenario: Calling a non-specified genomer plugin
    Given I run the genomer command with the arguments "init project"
      And I cd to "project"
     When I run the genomer command with the arguments "simple"
     Then the exit status should be 1
      And the output should contain:
     """
     Error. Unknown command or plugin 'simple.'
     run `genomer help` for a list of available commands

     """
