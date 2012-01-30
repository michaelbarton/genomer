GENOMER = File.join %W|#{File.dirname(__FILE__)} .. .. bin genomer|

Given /^I run the genomer command with no arguments/ do
  step "I run `#{GENOMER}`"
end

Given /^I run the genomer command with the arguments "([^"]*)"$/ do |args|
  genomer = File.join %W| #{File.dirname(__FILE__)} .. .. bin genomer|
  step "I run `#{GENOMER} #{args}`"
end
