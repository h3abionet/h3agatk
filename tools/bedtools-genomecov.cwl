#!/usr/bin/env cwl-runner
cwlVersion: "v1.0"
class: CommandLineTool
doc: |
  bedtools-genomecov.cwl is developed for CWL consortium

  Original tool usage:
      Tool:    bedtools genomecov (aka genomeCoverageBed)
      Sources: https://github.com/arq5x/bedtools2
      Summary: Compute the coverage of a feature file among a genome.
      Usage: bedtools genomecov [OPTIONS] -i <bed/gff/vcf> -g <genome>
requirements:
- $import: envvar-global.yml
- $import: bedtools-docker.yml
- class: InlineJavascriptRequirement

inputs:
  input:
    doc: |
      The input file can be in BAM format
          (Note: BAM _must_ be sorted by position)
      or <bed/gff/vcf>
    type: File
    secondaryFiles: |
      ${
       if ((/.*\.bam$/i).test(inputs.input.path))
          return {"path": inputs.input.path+".bai", "class": "File"};
       return [];
      }
    inputBinding:
      position: 1
      valueFrom: |
        ${
          var prefix = ((/.*\.bam$/i).test(inputs.input.path))?'-ibam':'-i';
          return [prefix,inputs.input.path];
        }
  genomeFile:
    doc: Input genome file.
    type: File
    inputBinding:
      position: 2
      prefix: "-g"

  dept:
    type:
      name: "JustDepts"
      type: enum
      symbols: ["-bg", "-bga", "-d"]
    inputBinding:
      position: 4

  scale:
    doc: |
      Scale the coverage by a constant factor.
      Each coverage value is multiplied by this factor before being reported.
      Useful for normalizing coverage by, e.g., reads per million (RPM).
      - Default is 1.0; i.e., unscaled.
      - (FLOAT)
    type: float?
    inputBinding:
      position: 4
      prefix: -scale

  dz:
    doc: |
      Report the depth at each genome position (with zero-based coordinates).
      Reports only non-zero positions.
      Default behavior is to report a histogram.
    type: boolean?
    inputBinding:
      position: 4
      prefix: "-dz"

  split:
    doc: |
      reat "split" BAM or BED12 entries as distinct BED intervals.
      when computing coverage.
      For BAM files, this uses the CIGAR "N" and "D" operations
      to infer the blocks for computing coverage.
      For BED12 files, this uses the BlockCount, BlockStarts, and BlockEnds
      fields (i.e., columns 10,11,12).
    type: boolean?
    inputBinding:
      position: 4
      prefix: "-split"

  strand:
    doc: |
      Calculate coverage of intervals from a specific strand.
      With BED files, requires at least 6 columns (strand is column 6).
      - (STRING): can be + or -
    type: string?
    inputBinding:
      position: 4
      prefix: "-strand"

  pairchip:
    doc: "pair-end chip seq experiment"
    type: boolean?
    inputBinding:
      position: 4
      prefix: "-pc"

  fragmentsize:
    doc: "fixed fragment size"
    type: int?
    inputBinding:
      position: 4
      prefix: "-fs"

  max:
    doc: |
      Combine all positions with a depth >= max into
      a single bin in the histogram. Irrelevant
      for -d and -bedGraph
      - (INTEGER)
    type: int?
    inputBinding:
      position: 4
      prefix: "-max"

  m5:
    doc: |
      Calculate coverage of 5" positions (instead of entire interval).
    type: boolean?
    inputBinding:
      position: 4
      prefix: "-5"

  m3:
    doc: |
      Calculate coverage of 3" positions (instead of entire interval).
    type: boolean?
    inputBinding:
      position: 4
      prefix: "-3"

  genomecoverageout: string
baseCommand: ["bedtools", "genomecov"]
stdout: $(inputs.genomecoverageout)
outputs:
  genomecoverage:
    doc: "The file containing the genome coverage"
    type: File
    outputBinding:
      glob: $(inputs.genomecoverageout)

$namespaces:
  foaf: http://xmlns.com/foaf/0.1/
  doap: http://usefulinc.com/ns/doap#

$schemas:
- http://xmlns.com/foaf/spec/20140114.rdf
- http://usefulinc.com/ns/doap#

doap:maintainer:
- class: foaf:Organization
  foaf:name: "Barski Lab, Cincinnati Children's Hospital Medical Center"
  foaf:member:
  - class: foaf:Person
    id: "http://orcid.org/0000-0001-9102-5681"
    foaf:openid: "http://orcid.org/0000-0001-9102-5681"
    foaf:name: "Andrey Kartashov"
    foaf:mbox: "mailto:Andrey.Kartashov@cchmc.org"

