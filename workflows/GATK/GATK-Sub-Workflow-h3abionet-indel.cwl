#!/usr/bin/env cwl-runner

class: Workflow
cwlVersion: v1.0

requirements:
  - class: StepInputExpressionRequirement
  - class: InlineJavascriptRequirement

inputs:
  reference:
    type: File
    doc: reference human genome file

  indel_mode:
    type: string
    default: 'INDEL'

  snp_mode:
    type: string
    default: 'SNP'

  snpf_genome:
    type: string

  snpf_nodownload:
    type: boolean

  snpf_data_dir:
    type: Directory

  resource_mills:
    type: File

  haplotest_vcf:
    type: File

  resource_hapmap:
    type: File

  resource_omni:
    type: File

  resource_dbsnp:
    type: File

outputs:
  recal_File:
    type: File
    outputSource: vqsr_indels/recal_File

  annotated_indels:
    type: File
    outputSource: snpeff_indels/annotated_vcf

steps:

  vqsr_indels:
    run: ../../tools/GATK-VariantRecalibrator-Indels.cwl
    in:
      #haplotypecaller_snps_vcf: HaplotypeCaller/output_HaplotypeCaller
      haplotypecaller_snps_vcf: haplotest_vcf
      reference: reference
      #resource_mills: indels_resource_mills
      resource_dbsnp: resource_dbsnp
      resource_omni: resource_omni
      resource_hapmap: resource_hapmap
      resource_mills: resource_mills
    out: [tranches_File, recal_File]

  apply_recalibration_indels:
    run: ../../tools/GATK-ApplyRecalibration.cwl
    in:
      mode: indel_mode
      #raw_vcf: HaplotypeCaller/output_HaplotypeCaller
      raw_vcf: haplotest_vcf
      reference: reference
      recal_file: vqsr_indels/recal_File
      tranches_file: vqsr_indels/tranches_File
    out: [ vqsr_vcf ]

  snpeff_indels:
    run: ../../tools/snpEff.cwl
    in:
      genome: snpf_genome
      variant_calling_file: apply_recalibration_indels/vqsr_vcf
      nodownload: snpf_nodownload
      data_dir: snpf_data_dir
    out: [ annotated_vcf ]
