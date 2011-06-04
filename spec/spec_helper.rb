$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'tempfile'
require 'rspec'
require 'fakefs/spec_helpers'
require 'mocha'
require 'bio'
require 'genomer'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each do |f|
  require File.expand_path(f)
end

RSpec.configure do |config|
  config.mock_with :mocha
end
