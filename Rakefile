require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  $stderr.puts "Run `rake install_fake` to install test plugin"
  exit e.status_code
end
require 'rake/dsl_definition'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  gem.name = "genomer"
  gem.homepage = "http://github.com/michaelbarton/genomer"
  gem.license = "MIT"
  gem.summary = %Q{Build genome output files}
  gem.description = %Q{Turns scaffolded contigs and annotations into a genome.}
  gem.email = "mail@michaelbarton.me.uk"
  gem.authors = ["Michael Barton"]
end
Jeweler::RubygemsDotOrgTasks.new

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

require 'cucumber/rake/task'
Cucumber::Rake::Task.new(:features)

task :default => :spec
