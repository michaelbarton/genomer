Given /^the Rules file has the text:$/ do |table|
  @rule_file = Tempfile.new('genomer_test')
  File.open(@rule_file.path,'a') do |out|
    table.hashes.each{ |i| out.puts(i['line']) }
  end
end

Given /^the scaffold file is called "([^"]*)"$/ do |file|
  tmp = write_scaffold_file(@entries)
  FileUtils.mv(tmp,file)
end

Given /^the sequence file is called "([^"]*)"$/ do |file|
  tmp = write_sequence_file(@sequences)
  FileUtils.mv(tmp,file)
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

Then /^"([^"]*)" should contain the sequence "([^"]*)"$/ do |file,seq|
  Bio::FlatFile.auto(file) do |ff|
    ff.first.seq.upcase.should == seq.upcase
  end
end
