Feature: Using plugins as part of a genomer project
  In order to use third-party genomer plugins
  A user can specify genomer plugins in a Gemfile
  So that these plugins are available on the command line

  @disable-bundler
  Scenario: Running help with no genomer plugins specified
    Given I run the genomer command with the arguments "init project"
      And I cd to "project"
      And I append to "Gemfile" with ""
     When I run the genomer command with the arguments "help"
     Then the exit status should be 0
      And the output should contain:
     """
     genomer COMMAND [options]

     Available commands:
       init        Create a new genomer project
     """

  @disable-bundler
  Scenario: Running help with a single genomer plugins specified
    Given I run the genomer command with the arguments "init project"
      And I cd to "project"
      And I append to "Gemfile" with:
      """
      gem 'genomer-plugin-simple', :path => '../../../genomer-plugin-simple'
      """
     When I run the genomer command with the arguments "help"
     Then the exit status should be 0
      And the output should contain:
     """
     genomer COMMAND [options]

     Available commands:
       init        Create a new genomer project
       simple      Simple genomer plugin for testing purposes
     """

  @disable-bundler
  Scenario: Calling a non-specified genomer plugin
    Given I run the genomer command with the arguments "init project"
      And I cd to "project"
      And I append to "Gemfile" with ""
     When I run the genomer command with the arguments "simple"
     Then the exit status should be 1
      And the output should contain:
     """
     Error. Unknown command or plugin 'simple.'
     run `genomer help` for a list of available commands

     """

  @disable-bundler
  Scenario: Calling a genomer plugin
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
  Scenario: Calling a genomer plugin with arguments
    Given I run the genomer command with the arguments "init project"
      And I cd to "project"
      And I append to "Gemfile" with:
      """
      gem 'genomer-plugin-simple', :path => '../../../genomer-plugin-simple'
      """
     When I run the genomer command with the arguments "simple arg1"
     Then the exit status should be 0
      And the output should contain:
     """
     Plugin "simple" called with arguments: arg1
     """

