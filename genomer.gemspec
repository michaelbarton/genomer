# -*- encoding: utf-8 -*-
require File.expand_path("../lib/genomer/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "genomer"
  s.version     = Genomer::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Michael Barton"]
  s.email       = ["mail@michaelbarton.me.uk"]
  s.homepage    = "http://next.gs"
  s.summary     = %Q{Build genome output files}
  s.description = %Q{Turns scaffolded contigs and annotations into a genome.}
  s.license     = "MIT"

  s.required_rubygems_version = ">= 1.8.0"
  s.rubyforge_project         = "genomer"

  s.add_dependency "rake",                          "~> 10.1.0"
  s.add_dependency "bundler",                       "~> 1.3.0"
  s.add_dependency "configliere",                   "~> 0.4.0"
  s.add_dependency "scaffolder",                    "~> 0.5.0"
  s.add_dependency "scaffolder-annotation-locator", "~> 0.2.0"
  s.add_dependency "unindent",                      "~> 1.0.0"
  s.add_dependency "md2man",                        "~> 1.2.0"

  # Specs
  s.add_development_dependency "rspec",                   "~> 2.14.0"
  s.add_development_dependency "fakefs",                  "~> 0.4.0"
  s.add_development_dependency "rr",                      "~> 1.1.0"
  s.add_development_dependency "scaffolder-test-helpers", "~> 0.4.0"

  # Features
  s.add_development_dependency "cucumber", "~> 1.1.4"
  s.add_development_dependency "aruba",    "~> 0.4.11"

  s.files        = `git ls-files`.split("\n")
  s.executables  = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.require_path = 'lib'
end
