#!/usr/bin/env cwl-runner
cwlVersion: "v1.0"
class: CommandLineTool
doc: |
  picard-CreateSequenceDictionary.cwl is developed for CWL consortium
  Read fasta or fasta.gz containing reference sequences, and write as a SAM or BAM file with only sequence dictionary.
requirements:
- $import: envvar-global.yml
- $import: picard-docker.yml
- class: InlineJavascriptRequirement

inputs:
  reference:
    doc: |
      Input reference fasta or fasta.gz
    type: File
    inputBinding:
      prefix: "REFERENCE="
      separate: false
      position: 4

  output_filename:
    doc: |
      Output SAM or BAM file containing only the sequence dictionary
    type: string
    inputBinding:
      prefix: "OUTPUT="
      separate: false
      position: 4

  GENOME_ASSEMBLY:
    doc: |
      Put into AS field of sequence dictionary entry if supplied
    type: string?
    inputBinding:
      prefix: "GENOME_ASSEMBLY="
      separate: false
      position: 4

  URI:
    doc: |
      Put into UR field of sequence dictionary entry.
      If not supplied, input reference file is used
    type: string?
    inputBinding:
      prefix: "URI="
      separate: false
      position: 4

  SPECIES:
    doc: |
      Put into SP field of sequence dictionary entry
    type: string?
    inputBinding:
      prefix: "SPECIES="
      separate: false
      position: 4

  TRUNCATE_NAMES_AT_WHITESPACE:
    doc: |
      Make sequence name the first word from the > line in the fasta file.  By default the
      entire contents of the > line is used, excluding leading and trailing whitespace.
      Default value: true. This option can be set to 'null' to clear the default value.
      Possible values: {true, false}
    type: boolean?
    inputBinding:
      prefix: "TRUNCATE_NAMES_AT_WHITESPACE="
      separate: false
      position: 4

  NUM_SEQUENCES:
    doc: |
      Stop after writing this many sequences.  For testing.
      Default value: 2147483647.
    type: int?
    inputBinding:
      prefix: "NUM_SEQUENCES="
      separate: false
      position: 4

baseCommand: "java"
arguments:
- valueFrom: "-Xmx4g"
  position: 1
- valueFrom: "/usr/local/bin/picard.jar"
  position: 2
  prefix: "-jar"
- valueFrom: "CreateSequenceDictionary"
  position: 3
outputs:
  output:
    doc: |
      Output SAM or BAM file containing only the sequence dictionary Required.
    type: File
    outputBinding:
      glob: $(inputs.output_filename)

