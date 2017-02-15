#!/bin/bash

# The following line causes bash to exit at any point if there is any error
# and to output each line as it is executed -- useful for debugging
set -e -x -o pipefail

dx-download-all-inputs --parallel

# move inputs to home
mv ~/in/gatk_jar_file/* ~/GenomeAnalysisTK.jar
mv ~/in/inhouse_annotations/* ~/inhouse.vcf.gz
mv ~/in/test_vcf/* ~/test.vcf
mv ~/in/reference_genome/* ~/genome.fa

# Show all the java versions installed on this worker
# Show the java version the worker is using
echo $(java -version)


# Use java7 as the default java version. 
# If java7 doesn't work with the GATK version (3.6 and above) then switch to java8 and try again.
#
update-alternatives --set java /usr/lib/jvm/java-7-openjdk-amd64/jre/bin/java
java -jar GenomeAnalysisTK.jar -version || (update-alternatives --set java /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java && java -jar GenomeAnalysisTK.jar -version)

#
# Calculate 80% of memory size, for java
#
head -n1 /proc/meminfo | awk '{print int($2*0.8/1024)}' >.mem_in_mb.txt
java="java -Xmx$(<.mem_in_mb.txt)m"

#  create the reference indexes
samtools faidx genome.fa
java -jar picard.jar CreateSequenceDictionary R= genome.fa O= genome.dict

# index the inhouse vcf
tabix -p vcf ~/inhouse.vcf.gz

# run variant annotator
$java -jar GenomeAnalysisTK.jar -T VariantAnnotator -R genome.fa -o output.inhouse.vcf.gz --resource:Inhouse ~/inhouse.vcf.gz --resourceAlleleConcordance -E Inhouse.PreviousClassification -V ~/inhouse.vcf.gz
#tabix -p vcf output.inhouse.vcf.gz

#mark-section "uploading results"
mkdir -p ~/out/vcf/output/ 
mv output.inhouse.vcf.gz ~/out/vcf/output/"$test_vcf_prefix".inhouse.vcf.gz
mv output.inhouse.vcf.gz.tbi ~/out/vcf/output/"$test_vcf_prefix".inhouse.vcf.gz.tbi

#
# Upload results
#
dx-upload-all-outputs --parallel
#mark-success
