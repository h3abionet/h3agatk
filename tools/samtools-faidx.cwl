#!/usr/bin/env cwl-runner
cwlVersion: "v1.0"
class: CommandLineTool
doc: |
  samtools-faidx.cwl is developed for CWL consortium
  Usage:   samtools faidx <file.fa|file.fa.gz> [<reg> [...]]
requirements:
- $import: envvar-global.yml
- $import: samtools-docker.yml
- class: InlineJavascriptRequirement
- class: InitialWorkDirRequirement
  listing:
  - entryname: $(inputs.input.path.split('/').slice(-1)[0])
    entry: $(inputs.input)
inputs:
  input:
    doc: '<file.fa|file.fa.gz>'
    type: File
  region:
    type: string?
    inputBinding:
      position: 2

baseCommand:
- samtools
- faidx

arguments:
- valueFrom: $(inputs.input.path.split('/').slice(-1)[0])
  position: 1

outputs:
  index:
    type: File
    secondaryFiles:
    - .fai
    - .gzi

    outputBinding:
      glob: $(inputs.input.path.split('/').slice(-1)[0]) #+'.fai')
$namespaces:
  s: http://schema.org/

$schemas:
- http://schema.org/version/9.0/schemaorg-current-http.rdf

s:mainEntity:
  $import: samtools-metadata.yaml

s:downloadUrl: https://github.com/common-workflow-language/workflows/blob/master/tools/samtools-faidx.cwl
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

