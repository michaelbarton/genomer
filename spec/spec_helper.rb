$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'rspec'
require 'fakefs/spec_helpers'
require 'scaffolder/test/helpers'

require 'genomer'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each do |f|
  require File.expand_path(f)
end

RSpec.configure do |config|
  config.mock_with :rr

  include Scaffolder::Test
  include Scaffolder::Test::Helpers

  class MockSettings

    attr :rest

    def initialize(rest = [], command_args = {})
      @rest = rest
      @args = command_args
    end

    def [](arg)
      @args[arg]
    end

    def flags
      @args
    end

  end

  config.after(:each) do
    instance_variables.each do |ivar|
      instance_variable_set(ivar, nil)
    end
  end
end
