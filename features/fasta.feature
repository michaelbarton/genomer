Feature: Generating fasta output
  In order to generate a genome in fasta format
  A user can use the fasta output option

  Scenario: Generating a simple fasta file
    Given the Rules file has the text:
      | line                               |
      | scaffold_file '/tmp/scaffold.yml'  |
      | sequence_file '/tmp/sequences.fna' |
      | out_file_name 'genome'             |
      | output :fasta                      |
    And the scaffold is composed of the sequences:
      | name | nucleotides |
      | seq  | ATGCC       |
    And the scaffold file is called "/tmp/scaffold.yml"
    And the sequence file is called "/tmp/sequences.fna"
    When the genomer executable is invoked
    Then genomer should exit without any error
    And the file "genome.fna" should exist
    And "genome.fna" should contain the sequence "ATGCC"
