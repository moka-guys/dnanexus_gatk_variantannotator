#!/bin/bash

# The following line causes bash to exit at any point if there is any error
# and to output each line as it is executed -- useful for debugging
set -e -x -o pipefail

#Grab inputs
dx-download-all-inputs --parallel

# Move inputs to home
mv ~/in/gatk_jar_file/* ~/GenomeAnalysisTK.jar
mv ~/in/prev_class/* ~/inhouse.vcf.gz
mv ~/in/sample_vcf/* ~/sample.vcf.gz
mv ~/in/reference_genome/* ~/genome.tar.gz

# Show the java version the worker is using
# Note: Have only specified java8 in json as opposed to loading up 7 & 8 as per DNAnexus GATK app - that's only really necessary if you want to be able to use older versions of GATK, which we don't do
echo $(java -version)

# Calculate 80% of memory size, for java
head -n1 /proc/meminfo | awk '{print int($2*0.8/1024)}' >.mem_in_mb.txt
java="java -Xmx$(<.mem_in_mb.txt)m"

# Decompress reference genome bundle for GATK
tar zxf genome.tar.gz

# rename genome files to grch37 so that the VCF header states the reference to be grch37.fa, which then allows Ingenuity to accept the VCFs (otherwise VCF header would have reference as genome.fa which Ingenuity won't accept)
mv genome.fa grch37.fa
mv genome.fai grch37.fai
mv genome.dict grch37.dict

# Index the vcfs
mark-section "Index vcf files"
tabix -p vcf ~/inhouse.vcf.gz
tabix -p vcf ~/sample.vcf.gz

# Run variant annotator
mark-section "Run GATK VariantAnnotator"
$java -jar GenomeAnalysisTK.jar -nt 4 -T VariantAnnotator -R grch37.fa -V sample.vcf.gz -o output.vcf.gz --resource:inhouse inhouse.vcf.gz --resourceAlleleConcordance -E inhouse.PrevClass 

# Send output back to DNAnexus project
mark-section "Upload output"
mkdir -p ~/out/vcf/output/ 
mv output.vcf.gz ~/out/vcf/output/"$sample_vcf_prefix".PrevClass.vcf.gz
dx-upload-all-outputs --parallel

mark-success
