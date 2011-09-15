GENOMER = File.join %W|#{File.dirname(__FILE__)} .. .. bin genomer|

Given /^I run the genomer command with no arguments/ do
  Given "I run `#{GENOMER}`"
end

Given /^I run the genomer command with the arguments "([^"]*)"$/ do |args|
  genomer = File.join %W| #{File.dirname(__FILE__)} .. .. bin genomer|
  Given "I run `#{GENOMER} #{args}`"
end

Given /^I have installed the gem "([^"]*)"$/ do |gem|
  gem_dir = File.join(File.dirname(__FILE__),'..',gem)
  gemspec = File.join(gem_dir, gem + '.gemspec')

  `gem build #{gemspec}`
  `gem install #{gem}-0.0.0.gem`
end
