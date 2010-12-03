Feature: Generating genbank output
  In order to generate a genome in genbank format
  A user can use the genbank output option

  Scenario: Generating a simple genbank file
    Given the Rules file has the text:
      | line                               |
      | scaffold_file '/tmp/scaffold.yml'  |
      | sequence_file '/tmp/sequences.fna' |
      | out_file_name 'genome'             |
      | out_dir_name '/tmp'                |
      | output :genbank                    |
    And the scaffold is composed of the sequences:
      | name | nucleotides |
      | seq  | ATGCC       |
    And the scaffold file is called "/tmp/scaffold.yml"
    And the sequence file is called "/tmp/sequences.fna"
    When the genomer executable is invoked
    Then genomer should exit without any error
    And the file "/tmp/genome.gb" should exist
    And "/tmp/genome.gb" should contain the sequence "ATGCC"
