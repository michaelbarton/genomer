Feature: Generating fasta output
  In order to generate a genome in fasta format
  A user can use the fasta output option

  Scenario: Generating a simple fasta file
    Given the Rules file has the text "scaffold 'scaffold.yml'"
    And the Rules file has the text "sequences 'sequences.fna'"
    And the Rules file has the text "output :fasta"
    And the scaffold is composed of the sequences:
      | name | nucleotides |
      | seq  | ATGCC       |
    When the genomer executable is invoked
    Then genomer should exit without any error
    And the file "genome.fna" should exist
    And the file "genome.fna" should contain the sequence "ATGCC"
