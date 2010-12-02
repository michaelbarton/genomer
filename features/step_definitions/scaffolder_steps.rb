Given /^the scaffold is composed of the sequences:$/ do |sequences|
  @entries = sequences.hashes.map do |seq|
    {'sequence' => {'source' => seq['name']}}
  end
  @sequences = sequences.hashes.map do |seq|
    {:name => seq['name'], :sequence => seq['nucleotides']}
  end
end

Given /^the first scaffold sequence has the inserts:$/ do |inserts|
  sequence = @entries.detect{|s| s.keys.first == 'sequence' }
  sequence['sequence']['inserts'] = (inserts.hashes.map do |insert|
    i = {'source' => insert['name']}
    i['open']  = insert['open'].to_i  if insert['open']
    i['close'] = insert['close'].to_i if insert['close']
    i
  end)
  inserts.hashes.map do |insert|
    @sequences << {:name => insert['name'], :sequence => insert['nucleotides']}
  end
end

When /^creating a scaffolder object$/ do
  @scf_file = write_scaffold_file(@entries)
  @seq_file = write_sequence_file(@sequences)

  @scaffold = Scaffolder.new(YAML.load(File.read(@scf_file)),@seq_file)
end

Then /^the scaffold should contain (.*) sequence entries$/ do |n|
  @scaffold.select{|s| s.entry_type == :sequence}.length.should == n.to_i
end

Then /^the scaffold should contain (.*) insert entries$/ do |n|
  @scaffold.select{|s| s.entry_type == :sequence}.inject(0) do |count,seq|
    count =+ seq.inserts.length
  end.should == n.to_i
end

And /^the scaffold sequence should be (.*)$/ do |sequence|
  generated_sequence = @scaffold.inject(String.new) do |build,entry|
    build << entry.sequence
  end
  generated_sequence.should == sequence
end
