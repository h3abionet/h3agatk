#!/usr/bin/env cwl-runner
cwlVersion: "v1.0"
class: CommandLineTool
doc: |
  About:   Concatenate or combine VCF/BCF files. All source files must have the same sample
           columns appearing in the same order. The program can be used, for example, to
           concatenate chromosome VCFs into one VCF, or combine a SNP VCF and an indel
           VCF into one. The input files must be sorted by chr and position. The files
           must be given in the correct order to produce sorted VCF on output unless
           the -a, --allow-overlaps option is specified.

  Usage:   bcftools concat [options] <A.vcf.gz> [<B.vcf.gz> [...]]
requirements:
- $import: envvar-global.yml
- $import: bcftools-docker.yml
- class: InlineJavascriptRequirement

inputs:
  filename:
    doc: |
      Write output to a file [standard output]
    type: string
    inputBinding:
      position: 1
      prefix: '-o'

  vcfs:
    type:
      type: array
      items: File
    secondaryFiles:
    - ".tbi"
    inputBinding:
      position: 2

  allow_overlaps:
    doc: |
      First coordinate of the next file can precede last record of the current file.
    type: boolean?
    inputBinding:
      position: 1
      prefix: '-a'

  compact_PS:
    doc: |
      Do not output PS tag at each site, only at the start of a new phase set block.
    type: boolean?
    inputBinding:
      position: 1
      prefix: '-c'

  rm_dups:
    doc: |
      Output duplicate records present in multiple files only once: <snps|indels|both|all|none>
    type: string?
    inputBinding:
      position: 1
      prefix: '-d'

  remove_duplicates:
    doc: |
      Alias for -d/--rm-dups none
    type: boolean?
    inputBinding:
      position: 1
      prefix: '-D'

  file_list:
    doc: |
      Read the list of files from a file.
    type: File?
    inputBinding:
      position: 1
      prefix: '-f'

  ligate:
    doc: |
      Ligate phased VCFs by matching phase at overlapping haplotypes
    type: boolean?
    inputBinding:
      position: 1
      prefix: '-l'

  output_type:
    doc: |
      <b|u|z|v> b: compressed BCF, u: uncompressed BCF, z: compressed VCF, v: uncompressed VCF [v]
    type: string?
    inputBinding:
      position: 1
      separate: false
      prefix: '-O'

  min_PQ:
    doc: |
      Break phase set if phasing quality is lower than <int> [30]
    type: int?
    inputBinding:
      position: 1
      prefix: '-q'

  regions:
    doc: |
      Restrict to comma-separated list of regions
    type: string?
    inputBinding:
      position: 1
      prefix: '-r'

  regions_file:
    doc: |
      Restrict to regions listed in a file
    type: File?
    inputBinding:
      position: 1
      prefix: '-R'

  threads:
    doc: |
      Number of extra output compression threads [0]
    type: int?
    inputBinding:
      position: 1
      prefix: '--threads'

baseCommand:
- bcftools
- concat

outputs:
  output:
    type: File
    outputBinding:
      glob: $(inputs.filename)

