Feature: Listing available commands
  In order to know which commands are available
  A user can use the help command
  To list the available options to the console

  Scenario: Running the genomer command
     When I run the genomer command with no arguments
     Then the output should contain:
     """
     genomer COMMAND [options]
     run `genomer help` for a list of available commands`

     """
