source "http://rubygems.org"

group :default do
  gem "configliere", "~> 0.4.8"
  gem "unindent",    "~> 1.0.0"
  gem "bundler",     "~> 1.0.0"
end

group :development do
  gem "jeweler",  "~> 1.5"

  # Specs
  gem "rspec",    "~> 2.6"
  gem "fakefs",   "~> 0.4.0"
  gem "rr",       "~> 1.0.4"

  # Features
  gem "cucumber", "~> 1.0.4"
  gem "aruba",    "~> 0.4.6"

  # Fake gem for testing
  gem "genomer-plugin-fake", "0.0.0", :path => "#{File.dirname(__FILE__)}/features/genomer-plugin-fake/"
end
