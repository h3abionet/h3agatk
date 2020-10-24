#!/usr/bin/env cwl-runner
cwlVersion: "v1.0"
class: CommandLineTool
doc: |
  samtools-rmdup.cwl is developed for CWL consortium
requirements:
- $import: envvar-global.yml
- $import: samtools-docker.yml
- class: InlineJavascriptRequirement

inputs:
  input:
    doc: |
      Input bam file.
    type: File
    inputBinding:
      position: 2

  output_name:
    type: string
    inputBinding:
      position: 3

  single_end:
    doc: |
      rmdup for SE reads
    type: boolean
    default: false
  pairend_as_se:
    doc: |
      treat PE reads as SE in rmdup (force -s)
    type: boolean
    default: false
baseCommand: ["samtools", "rmdup"]
outputs:
  rmdup:
    doc: "File with removed duplicates"
    type: File
    outputBinding:
      glob: $(inputs.output_name)

$namespaces:
  s: http://schema.org/

$schemas:
- http://schema.org/version/9.0/schemaorg-current-http.rdf

s:mainEntity:
  $import: samtools-metadata.yaml

s:downloadUrl: https://github.com/common-workflow-language/workflows/blob/master/tools/samtools-rmdup.cwl
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
