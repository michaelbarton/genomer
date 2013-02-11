$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'rspec'
require 'fakefs/spec_helpers'
require 'scaffolder/test/helpers'

require 'genomer'
require 'genomer/version'

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

    def initialize(rest = [], args = {})
      @rest = rest
      @args = args
    end

    def method_missing(method, *args, &block)
      @args.send(method, *args, &block)
    end

  end

  config.after(:each) do
    instance_variables.each do |ivar|
      instance_variable_set(ivar, nil)
    end
  end
end
