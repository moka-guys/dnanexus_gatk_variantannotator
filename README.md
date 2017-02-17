# dnanexus_gatk_variantannotator

Uses GATK VariantAnnotator function to annotate sample's VCF with INFO fields from another VCF.

Requires the sample VCF to be derived from alignment to hs37ds.
This is the case for samples run through Mokapipe.

##Inputs:
*GATK app
*Sample VCF
*Previous classifications VCF
*Reference genome bundle (hs37d5.fasta-index.tar.gz in 001)
