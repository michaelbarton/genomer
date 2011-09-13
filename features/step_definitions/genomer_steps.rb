Given /^I run the genomer command with the arguments "([^"]*)"$/ do |args|
  genomer = File.join %W| #{File.dirname(__FILE__)} .. .. bin genomer|
  Given "I successfully run `#{genomer} #{args}`"
end
