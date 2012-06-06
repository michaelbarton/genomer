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

  @disable-bundler
  Scenario: Getting the man page for a plugin
    Given I run the genomer command with the arguments "init project"
      And I cd to "project"
      And I overwrite "Gemfile" with:
      """
      gem 'genomer-plugin-simple', :path => '../../../genomer-plugin-simple'
      """
     When I run the genomer command with the arguments "man simple"
     Then the exit status should be 0
      And the output should contain "GENOMER-SIMPLE(1)"

  @disable-bundler
  Scenario: Getting the man page for a plugin subcommand
    Given I run the genomer command with the arguments "init project"
      And I cd to "project"
      And I overwrite "Gemfile" with:
      """
      gem 'genomer-plugin-simple', :path => '../../../genomer-plugin-simple'
      """
     When I run the genomer command with the arguments "man simple subcommand"
     Then the exit status should be 0
     And the output should contain "GENOMER-SIMPLE-SUBCOMMAND(1)"

  @disable-bundler
  Scenario: Trying to get a man page for an unknown plugin
    Given I run the genomer command with the arguments "init project"
      And I cd to "project"
      And I overwrite "Gemfile" with:
      """
      gem 'genomer-plugin-simple', :path => '../../../genomer-plugin-simple'
      """
     When I run the genomer command with the arguments "man unknown"
     Then the exit status should be 1
      And the output should contain:
      """
      Error. Unknown command or plugin 'unknown.'
      run `genomer help` for a list of available commands

      """

  @disable-bundler
  Scenario: Trying to get a man page for an unknown subcommand
    Given I run the genomer command with the arguments "init project"
      And I cd to "project"
      And I overwrite "Gemfile" with:
      """
      gem 'genomer-plugin-simple', :path => '../../../genomer-plugin-simple'
      """
     When I run the genomer command with the arguments "man simple unknown"
     Then the exit status should be 1
      And the output should contain:
      """
      Error. No manual entry for command 'simple unknown'

      """
