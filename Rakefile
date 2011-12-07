require 'rubygems'
require 'bundler'
gem 'psych'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  $stderr.puts "Run `rake install_fake` to install test plugin"
  exit e.status_code
end
require 'rake/dsl_definition'
require 'rspec/core'
require 'rspec/core/rake_task'
require 'cucumber/rake/task'


Bundler::GemHelper.install_tasks

RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

Cucumber::Rake::Task.new(:features)

task :default => :spec
