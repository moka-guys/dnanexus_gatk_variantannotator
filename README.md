# GATK Variant annotator v1.4

**Please read this important information before running the app.**
## What does this app do?

This app uses GATK variant annotator to annotate a VCF with the previous classifications using a vcf containing previously classified variants.

The annotated VCF can then be used in Ingenuity, using these annotations to identify previously reported (pathogenic variants) or previously identified sequencing artefacts.

##Requirements
Requires that the two VCFs are compatible with each other, which for our purposes means that the sample VCF is derived from alignment to hs37ds through Mokapipe, and the previous classifications VCF appears to have been generated the same way.

## What inputs are required?
1. GATK app
2. Sample VCF
3. Previous classifications VCF
4. Reference genome bundle (hs37d5.fasta-index.tar.gz in 001)


## What does this app output?
An annotated vcf (named refined.vcf to match the BAM file so can be viewed using biodalliance viewer)

### This App was created by Viapath Genome Informatics section.
