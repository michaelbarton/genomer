GENOMER = File.join %W|#{File.dirname(__FILE__)} .. .. bin genomer|

Given /^I run the genomer command with the arguments "([^"]*)"$/ do |args|
  step "I run `#{GENOMER} #{args}`"
end

Given /^I run the genomer command with no arguments/ do
  step 'I run the genomer command with the arguments ""'
end

