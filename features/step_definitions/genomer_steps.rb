Given /^an empty Rules file$/ do
  @file = Tempfile.new('genomer_test')
end

When /^the genomer executable is invoked$/ do
  @exit = system(GENOMER, @file.path)
end

Then /^genomer should exit without any error$/ do
  @exit.should be_true
  $CHILD_STATUS.should == 0
end
