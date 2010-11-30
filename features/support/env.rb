require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../../lib')
require 'genomer'

require 'tempfile'
require 'english'

require 'rspec/expectations'

GENOMER = File.join %W| #{File.dirname(__FILE__)} .. .. bin genomer|
