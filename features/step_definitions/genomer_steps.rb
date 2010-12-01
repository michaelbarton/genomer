Given /^the Rules file has the text "([^"]*)"$/ do |contents|
  @rule_file ||= Tempfile.new('genomer_test')
  File.open(@rule_file.path,'a'){|out| out.print contents }
end

When /^the genomer executable is invoked$/ do
  @clean = system(GENOMER, @rule_file.path)
end

Then /^genomer should exit without any error$/ do
  @clean.should be_true
  $CHILD_STATUS.should == 0
end

Then /^the file "([^"]*)" should exist$/ do |file|
  File.exists?(file).should be_true
end

Then /^the file "([^"]*)" should contain the sequence "([^"]*)"$/ do |f,s|
  seq = Bio::FlatFile.auto(f).first.sequence
  s.should == seq
end
