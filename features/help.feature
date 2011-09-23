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
     run `genomer help` for a list of available commands`

     """

  Scenario: Running genomer with the help command
     When I run the genomer command with the arguments "help"
     Then the exit status should be 0
      And the output should contain:
     """
     genomer COMMAND [options]

     Available commands:
     """

  Scenario: Running genomer with an unknown command
     When I run the genomer command with the arguments "unknown"
     Then the exit status should be 1
      And the output should contain:
     """
     Unknown command or plugin "fake"

     """
