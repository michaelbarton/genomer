Feature: Showing man pages for available commands
  In order to know which how to use genomer plugins
  A user can use the man command
  To show the man page for specified plugin

  Scenario: Running genomer man with no commands
     When I run the genomer command with the arguments "man"
     Then the exit status should be 0
      And the output should contain:
     """
     genomer man COMMAND
     run `genomer help` for a list of available commands

     """
