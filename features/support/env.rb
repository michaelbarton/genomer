require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../../lib')
require 'genomer'

require 'tempfile'
require 'english'

require 'rspec/expectations'

GENOMER = File.join %W| #{File.dirname(__FILE__)} .. .. bin genomer|

def write_sequence_file(*sequences)
  file = Tempfile.new("sequence").path
  File.open(file,'w') do |tmp|
    sequences.flatten.each do |sequence|
      seq = Bio::Sequence.new(sequence[:sequence])
      tmp.print(seq.output(:fasta,:header => sequence[:name]))
    end
  end
  file
end

def write_scaffold_file(scaffold)
  file = Tempfile.new("scaffold").path
  File.open(file,'w'){|tmp| tmp.print(YAML.dump(scaffold))}
  file
end
