#!/usr/bin/env cwl-runner
cwlVersion: "v1.0"
class: CommandLineTool
doc: |
  ucsc-liftOver.cwl is developed for CWL consortium
    usage:
       liftOver oldFile map.chain newFile unMapped
    oldFile and newFile are in bed format by default, but can be in GFF and
    maybe eventually others with the appropriate flags below.
    The map.chain file has the old genome as the target and the new genome
    as the query.

    ***********************************************************************
    WARNING: liftOver was only designed to work between different
             assemblies of the same organism. It may not do what you want
             if you are lifting between different organisms. If there has
             been a rearrangement in one of the species, the size of the
             region being mapped may change dramatically after mapping.
    ***********************************************************************
requirements:
- class: InlineJavascriptRequirement
- $import: envvar-global.yml
- $import: ucsc-userapps-docker.yml

inputs:
  oldFile:
    type: File
    inputBinding:
      position: 2

  mapChain:
    doc: |
      The map.chain file has the old genome as the target and the new genome
      as the query.
    type: File
    inputBinding:
      position: 3

  newFile:
    type: string
    inputBinding:
      position: 4

  unMapped:
    type: string
    inputBinding:
      position: 5

  gff:
    doc: |
      File is in gff/gtf format.  Note that the gff lines are converted
       separately.  It would be good to have a separate check after this
       that the lines that make up a gene model still make a plausible gene
       after liftOver
    type: boolean?
    inputBinding:
      position: 1
      prefix: "-gff"

  genePred:
    doc: |
      File is in genePred format
    type: boolean?
    inputBinding:
      position: 1
      prefix: "-genePred"

  sample:
    doc: |
      File is in sample format
    type: boolean?
    inputBinding:
      position: 1
      prefix: "-sample"

  bedPlus:
    doc: |
      =N - File is bed N+ format
    type: int?
    inputBinding:
      separate: false
      position: 1
      prefix: "-bedPlus="

  positions:
    doc: |
      File is in browser "position" format
    type: boolean?
    inputBinding:
      position: 1
      prefix: "-positions"

  hasBin:
    doc: |
      File has bin value (used only with -bedPlus)
    type: boolean?
    inputBinding:
      position: 1
      prefix: "-hasBin"

  minMatch:
    doc: |
      -minMatch=0.N Minimum ratio of bases that must remap. Default 0.95
    type: int?
    inputBinding:
      separate: false
      position: 1
      prefix: "-minMatch="

  tab:
    type: boolean?
    inputBinding:
      position: 1
      prefix: "-tab"

  pslT:
    doc: |
      File is in psl format, map target side only
    type: boolean?
    inputBinding:
      position: 1
      prefix: "-pslT"

  ends:
    doc: |
      =N - Lift the first and last N bases of each record and combine the
               result. This is useful for lifting large regions like BAC end pairs.
    type: int?
    inputBinding:
      separate: false
      position: 1
      prefix: "-ends="

  minBlocks:
    doc: |
      .N Minimum ratio of alignment blocks or exons that must map
                    (default 1.00)
    type: int?
    inputBinding:
      separate: false
      position: 1
      prefix: "-minBlocks="

  fudgeThick:
    doc: |
      (bed 12 or 12+ only) If thickStart/thickEnd is not mapped,
                    use the closest mapped base.  Recommended if using
                    -minBlocks.
    type: boolean?
    inputBinding:
      position: 1
      prefix: "-fudgeThick"

  multiple:
    doc: |
      Allow multiple output regions
    type: boolean?
    inputBinding:
      position: 1
      prefix: "-multiple"

  minChainT:
    doc: |
      Minimum chain size in target/query, when mapping
                             to multiple output regions (default 0, 0)
    type: int?
    inputBinding:
      position: 1
      prefix: "-minChainT"

  minChainQ:
    doc: |
      Minimum chain size in target/query, when mapping
                             to multiple output regions (default 0, 0)
    type: int?
    inputBinding:
      position: 1
      prefix: "-minChainQ"

  minSizeQ:
    doc: |
      Min matching region size in query with -multiple.
    type: int?
    inputBinding:
      position: 1
      prefix: "-minSizeQ"

  chainTable:
    doc: |
      Min matching region size in query with -multiple.
    type: string?
    inputBinding:
      position: 1
      prefix: "-chainTable"

baseCommand: "liftOver"
outputs:
  output:
    doc: "The sorted file"
    type: File
    outputBinding:
      glob: $(inputs.newFile)

  unMappedFile:
    doc: "The sorted file"
    type: File
    outputBinding:
      glob: $(inputs.unMapped)

$namespaces:
  s: http://schema.org/

$schemas:
- http://schema.org/version/9.0/schemaorg-current-http.rdf

s:mainEntity:
  $import: ucsc-metadata.yaml

s:downloadUrl: https://github.com/common-workflow-language/workflows/blob/master/tools/ucsc-liftOver.cwl
s:codeRepository: https://github.com/common-workflow-language/workflows
s:license: http://www.apache.org/licenses/LICENSE-2.0
s:isPartOf:
  class: s:CreativeWork
  s:name: "Common Workflow Language"
  s:url: http://commonwl.org/

s:author:
  class: s:Person
  s:name: "Andrey Kartashov"
  s:email: mailto:Andrey.Kartashov@cchmc.org
  s:sameAs:
  - id: http://orcid.org/0000-0001-9102-5681
  s:worksFor:
  - class: s:Organization
    s:name: "Cincinnati Children's Hospital Medical Center"
    s:location: "3333 Burnet Ave, Cincinnati, OH 45229-3026"
    s:department:
    - class: s:Organization
      s:name: "Barski Lab"
