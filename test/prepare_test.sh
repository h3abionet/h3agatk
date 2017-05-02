#!/usr/bin/env bash

# Script has to be run in current directory ./test

# download files from S3
for i in 1000G_omni2.5.hg19.sites.vcf 1000G_phase1.indels.hg19.sites.vcf 1000G_phase1.snps.high_confidence.hg19.sites.vcf Mills_and_1000G_gold_standard.indels.hg19.sites.vcf NA12878.R1.fastq.gz NA12878.R2.fastq.gz dbsnp_138.hg19.excluding_sites_after_129.vcf genome.fa genome.fa.64.amb genome.fa.64.ann genome.fa.64.bwt genome.fa.64.pac genome.fa.64.sa genome.fa.fai hapmap_3.3.hg19.sites.vcf snpEff_v4_3_hg19.zip; do echo $i; wget -q  https://s3-us-west-2.amazonaws.com/bd2k-test-data/h3abionet_gatk_workflow_data/$i; done;

# unzip the snpEff bundle
unzip snpEff_v4_3_hg19.zip
