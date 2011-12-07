Gem::Specification.new do |s|
  s.name        = "genomer-plugin-simple"
  s.version     = "0.0.0"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Michael Barton"]
  s.email       = ["mail@michaelbarton.me.uk"]
  s.homepage    = "http://next.gs"
  s.summary     = "Simple genomer plugin for testing purposes"
  s.description = "Empty"

  s.required_rubygems_version = ">= 1.8"

  # required for validation
  s.rubyforge_project         = "genomer-plugin-simple"

  s.files        = Dir["{lib}/**/*.rb"]
  s.require_path = 'lib'
end
