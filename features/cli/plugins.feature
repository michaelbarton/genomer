Feature: Calling genomer plugins in a genomer project
  In order to use third-party genomer plugins
  A user can specify genomer plugins in a Gemfile
  And call these plugins on the command line

  @disable-bundler
  Scenario: Calling a genomer plugin with no command
    Given I run the genomer command with the arguments "init project"
      And I cd to "project"
      And I append to "Gemfile" with:
      """
      gem 'genomer-plugin-simple', :path => '../../../genomer-plugin-simple'
      """
     When I run the genomer command with the arguments "simple"
     Then the exit status should be 0
      And the output should contain:
     """
     Plugin "simple" called
     """

  @disable-bundler
  Scenario: Calling a genomer plugin with a command
    Given I run the genomer command with the arguments "init project"
      And I cd to "project"
      And I append to "Gemfile" with:
      """
      gem 'genomer-plugin-simple', :path => '../../../genomer-plugin-simple'
      """
     When I run the genomer command with the arguments "simple echo some words"
     Then the exit status should be 0
      And the output should contain:
     """
     Echo: some words
     """
