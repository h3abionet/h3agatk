#!/usr/bin/env cwl-runner
cwlVersion: "v1.0"
class: CommandLineTool
doc: |
  GATK-FastaAlternateReferenceMaker.cwl is developed for CWL consortium
requirements:
- $import: envvar-global.yml
- $import: GATK-docker.yml
- class: InlineJavascriptRequirement

inputs:
  reference:
    doc: |
      Input reference fasta or fasta.gz
    type: File
    inputBinding:
      prefix: "-R"
      position: 4

  vcf:
    doc: |
      Input VCF file
      Variants from this VCF file are used by this tool as input. The file must at least contain the standard VCF header lines, but can be empty (i.e., no variants are contained in the file).
      --variant binds reference ordered data. This argument supports ROD files of the following types: BCF2, VCF, VCF3
    type: File
    inputBinding:
      prefix: "-V"
      position: 4

  intervals:
    type: File?
    inputBinding:
      prefix: "-L"
      position: 4

  snpmask:
    doc: |
      SNP mask VCF file
    type: File?
    inputBinding:
      prefix: "--snpmask"
      position: 4

  output_filename:
    type: string
    inputBinding:
      prefix: "-o"
      position: 4

baseCommand: "java"
arguments:
- valueFrom: "-Xmx4g"
  position: 1
- valueFrom: "/usr/local/bin/GenomeAnalysisTK.jar"
  position: 2
  prefix: "-jar"
- valueFrom: "FastaAlternateReferenceMaker"
  position: 3
  prefix: "-T"


outputs:
  output:
    doc: |
      An output file created by the walker. Will overwrite contents if file exists
    type: File
    outputBinding:
      glob: $(inputs.output_filename)

$namespaces:
  schema: http://schema.org/

$schemas:
- http://schema.org/version/9.0/schemaorg-current-http.rdf

schema:mainEntity:
  $import: GATK-metadata.yaml

schema:downloadUrl: https://github.com/common-workflow-language/workflows/blob/master/tools/GATK-FastaAlternateReferenceMaker.cwl
schema:codeRepository: https://github.com/common-workflow-language/workflows
schema:license: http://www.apache.org/licenses/LICENSE-2.0
schema:isPartOf:
  class: schema:CreativeWork
  schema:name: "Common Workflow Language"
  schema:url: http://commonwl.org/

schema:author:
  class: schema:Person
  schema:name: "Andrey Kartashov"
  schema:email: mailto:Andrey.Kartashov@cchmc.org
  schema:sameAs:
  - id: http://orcid.org/0000-0001-9102-5681
  schema:worksFor:
  - class: schema:Organization
    schema:name: "Cincinnati Children's Hospital Medical Center"
    schema:location: "3333 Burnet Ave, Cincinnati, OH 45229-3026"
    schema:department:
    - class: schema:Organization
      schema:name: "Barski Lab"

