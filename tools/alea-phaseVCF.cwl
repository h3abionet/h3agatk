#!/usr/bin/env cwl-runner
cwlVersion: "v1.0"
class: CommandLineTool
requirements:
- $import: envvar-global.yml
- $import: alea-docker.yml
- class: InlineJavascriptRequirement

inputs:
  hapsDir:
    doc: |
      path to the directory containing the .haps files
    type: File
    inputBinding:
      position: 2

  unphased:
    doc: |
      path to the vcf file containing unphased SNPs and Indels
    type: File
    inputBinding:
      position: 3

  outputPrefix:
    doc: |
      output file prefix including the path but not the extension
    type: string
    inputBinding:
      position: 3

baseCommand: ["alea", "phaseVCF"]
outputs:
  phasevcf:
    doc: "Creates the file outputPrefix.vcf.gz"
    type: File
    outputBinding:
      glob: $(inputs.outputPrefix+".vcf.gz")

$namespaces:
  s: http://schema.org/

$schemas:
- http://schema.org/version/9.0/schemaorg-current-http.rdf

s:mainEntity:
  $import: alea-metadata.yaml

s:downloadUrl: https://github.com/common-workflow-language/workflows/blob/master/tools/alea-phaseVCF.cwl
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
