#!/usr/bin/env cwl-runner

$namespaces:
  foaf: http://xmlns.com/foaf/0.1/
  doap: http://usefulinc.com/ns/doap#

$schemas:
- http://xmlns.com/foaf/spec/20140114.rdf
- http://usefulinc.com/ns/doap#

cwlVersion: "cwl:draft-3"

class: CommandLineTool

description: |
  bedtools-genomecov.cwl is developed for CWL consortium

  Original tool usage:
      Tool:    bedtools genomecov (aka genomeCoverageBed)
      Sources: https://github.com/arq5x/bedtools2
      Summary: Compute the coverage of a feature file among a genome.
      Usage: bedtools genomecov [OPTIONS] -i <bed/gff/vcf> -g <genome>

doap:maintainer:
- class: foaf:Organization
  foaf:name: "Barski Lab, Cincinnati Children's Hospital Medical Center"
  foaf:member:
  - class: foaf:Person
    id: "http://orcid.org/0000-0001-9102-5681"
    foaf:openid: "http://orcid.org/0000-0001-9102-5681"
    foaf:name: "Andrey Kartashov"
    foaf:mbox: "mailto:Andrey.Kartashov@cchmc.org"

requirements:
  - $import: envvar-global.yml
  - $import: bedtools-docker.yml
  - class: InlineJavascriptRequirement

inputs:
  - id: input
    type: File
    description: |
      The input file can be in BAM format
          (Note: BAM _must_ be sorted by position)
      or <bed/gff/vcf>
    inputBinding:
      position: 1
      valueFrom: |
          ${
            var prefix = ((/.*\.bam$/i).test(inputs.input.path))?'-ibam':'-i';
            return [prefix,inputs.input.path];
          }
    secondaryFiles: |
           ${
            if ((/.*\.bam$/i).test(inputs.input.path))
               return {"path": inputs.input.path+".bai", "class": "File"};
            return [];
           }

  - id: genomeFile
    type: File
    description:
      Input genome file.
    inputBinding:
      position: 2
      prefix: "-g"

  - id: dept
    type:
      name: "JustDepts"
      type: enum
      symbols: ["-bg","-bga","-d"]
    inputBinding:
      position: 4

  - id: scale
    type: ["null",float ]
    description: |
      Scale the coverage by a constant factor.
      Each coverage value is multiplied by this factor before being reported.
      Useful for normalizing coverage by, e.g., reads per million (RPM).
      - Default is 1.0; i.e., unscaled.
      - (FLOAT)
    inputBinding:
      position: 4
      prefix: -scale

  - id: dz
    type: ["null",boolean]
    description: |
      Report the depth at each genome position (with zero-based coordinates).
      Reports only non-zero positions.
      Default behavior is to report a histogram.
    inputBinding:
      position: 4
      prefix: "-dz"

  - id: split
    type: ["null",boolean]
    description: |
      reat "split" BAM or BED12 entries as distinct BED intervals.
      when computing coverage.
      For BAM files, this uses the CIGAR "N" and "D" operations
      to infer the blocks for computing coverage.
      For BED12 files, this uses the BlockCount, BlockStarts, and BlockEnds
      fields (i.e., columns 10,11,12).
    inputBinding:
      position: 4
      prefix: "-split"

  - id: strand
    type: ["null", string]
    description: |
      Calculate coverage of intervals from a specific strand.
      With BED files, requires at least 6 columns (strand is column 6).
      - (STRING): can be + or -
    inputBinding:
      position: 4
      prefix: "-strand"

  - id: pairchip
    type: ["null", boolean]
    description: "pair-end chip seq experiment"
    inputBinding:
      position: 4
      prefix: "-pc"

  - id: fragmentsize
    type: ["null", int]
    description: "fixed fragment size"
    inputBinding:
      position: 4
      prefix: "-fs"

  - id: max
    type: ["null",int]
    description: |
      Combine all positions with a depth >= max into
      a single bin in the histogram. Irrelevant
      for -d and -bedGraph
      - (INTEGER)
    inputBinding:
      position: 4
      prefix: "-max"

  - id: m5
    type: ["null",boolean]
    description: |
      Calculate coverage of 5" positions (instead of entire interval).
    inputBinding:
      position: 4
      prefix: "-5"

  - id: m3
    type: ["null",boolean]
    description: |
      Calculate coverage of 3" positions (instead of entire interval).
    inputBinding:
      position: 4
      prefix: "-3"

  - id: genomecoverageout
    type: string

outputs:
  - id: genomecoverage
    type: File
    description: "The file containing the genome coverage"
    outputBinding:
      glob: $(inputs.genomecoverageout)

stdout: $(inputs.genomecoverageout)

baseCommand: ["bedtools", "genomecov"]
