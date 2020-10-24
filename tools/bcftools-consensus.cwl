#!/usr/bin/env cwl-runner
cwlVersion: 'v1.0'
class: CommandLineTool
doc: |
  About:   Create consensus sequence by applying VCF variants to a reference
           fasta file.

  Usage:   bcftools consensus [OPTIONS] <file.vcf>

  Options:
      -f, --fasta-ref <file>     reference sequence in fasta format
      -H, --haplotype <1|2>      apply variants for the given haplotype
      -i, --iupac-codes          output variants in the form of IUPAC ambiguity
  codes
      -m, --mask <file>          replace regions with N
      -o, --output <file>        write output to a file [standard output]
      -c, --chain <file>         write a chain file for liftover
      -s, --sample <name>        apply variants of the given sample

  Examples:

     # Get the consensus for one region. The fasta header lines are then expected
     # in the form ">chr:from-to".
     samtools faidx ref.fa 8:11870-11890 | bcftools consensus in.vcf.gz > out.fa
requirements:
- $import: envvar-global.yml
- $import: bcftools-docker.yml
- class: InlineJavascriptRequirement
- class: ShellCommandRequirement

inputs:
  filename:
    doc: |
      write output to a file
    type: string
    inputBinding:
      position: 1
      prefix: '-o'

  vcf:
    type: File
    secondaryFiles:
    - .tbi

    inputBinding:
      position: 2
  reference:
    doc: |
      reference sequence in fasta format
    type: File
    inputBinding:
      position: 1
      prefix: '-f'

  haplotype:
    doc: |
      apply variants for the given haplotype <1|2>
    type: int?
    inputBinding:
      position: 1
      prefix: '-H'

  iupac_codes:
    doc: |
      output variants in the form of IUPAC ambiguity codes
    type: boolean?
    inputBinding:
      position: 1
      prefix: '-i'

  mask:
    doc: |
      replace regions with N
    type: File?
    inputBinding:
      position: 1
      prefix: '-m'

  chain:
    doc: |
      write a chain file for liftover
    type: string?
    inputBinding:
      position: 1
      prefix: '-c'

  sample:
    doc: |
      apply variants of the given sample
    type: string?
    inputBinding:
      position: 1
      prefix: '-s'

baseCommand:
- bcftools
- consensus

arguments:
- valueFrom: "2>/dev/null"
  position: 99
  shellQuote: false

outputs:
  output:
    type: File
    outputBinding:
      glob: $(inputs.filename)

  liftover:
    type: File
    outputBinding:
      glob: $(inputs.chain)

