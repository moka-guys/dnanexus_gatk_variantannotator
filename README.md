# dnanexus_gatk_variantannotator

Uses GATK VariantAnnotator function to annotate sample's VCF with INFO fields from another VCF (previous classifications).

Requires that the two VCFs are compatible with each other, which for our purposes means that the sample VCF is derived from alignment to hs37ds through Mokapipe, and the previous classifications VCF appears to have been generated the same way.

##Inputs:
* GATK app
* Sample VCF
* Previous classifications VCF
* Reference genome bundle (hs37d5.fasta-index.tar.gz in 001)
