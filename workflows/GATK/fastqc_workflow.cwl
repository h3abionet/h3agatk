cwlVersion: v1.0
class: Workflow

inputs:
 reads1: File

outputs:
  zippedFile:
    type: File
    outputSource: fastqc/zippedFile
  report:
    type: Directory
    outputSource: fastqc/report

steps:
  fastq:
    run: ../../tools/fastqc.cwl
    in:
      fastqFile: reads1
    out: [zippedFile,report]
