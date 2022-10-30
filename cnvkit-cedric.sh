# 1st step is to create the access.hg19.bed file. This commandcalculates the sequence-accessible coordinates in chromosomes from the given reference genome, output as a BED file
cnvkit.py access hg19.fa -o access.hg19.bed
# 2nd step is to create the bin size for the analyses (the dots). This command quickly estimates read counts or depths in a BAM file to estimate reasonable on- and off-target bin sizes.
# Generates target and antitarget BED files, and prints a table of estimated average read depths and recommended bin sizes on standard output.
cnvkit.py autobin ./samtools-deduped-bam/*.bam -t baits500.bed -g access.hg19.bed

# 3rd step is to create the *.targetcoverage.cnn file and *.antitargetcoverage.cnn. First create a folder called 'tumor500-cnn' to save the cnn files. 
# This command calculates coverage in the given regions from BAM read depths. By default, coverage is calculated via mean read depth from a pileup
# Use baits selector with add500bp. Create a text file with the sample list ('SampleList.txt')

while read p; do
 SAMPLE="$(echo $p | sed 's/.cfDNA.sorted.samtools-deduped.sorted.bam//g')"  
 echo "$SAMPLE"
 cnvkit.py coverage $p baits500.target.bed -o tumor500-cnn/${SAMPLE}.targetcoverage.cnn
 cnvkit.py coverage $p baits500.antitarget.bed -o tumor500-cnn/${SAMPLE}.antitargetcoverage.cnn
done <SampleList.txt

# Create the folder called 'control500-cnn' and use the same command but in the control samples. 
# In our case the BLYM_v2_AUG2021 controls. Create a text file with the sample list ('ControlList.txt') 

while read p; do
 SAMPLE="$(echo $p | sed 's/-c1_cfDNA.sorted.samtools-deduped.sorted.bam//g')"
 echo "$SAMPLE"
 cnvkit.py coverage $p baits500.target.bed -o control500-cnn/${SAMPLE}.targetcoverage.cnn
 cnvkit.py coverage $p baits500.antitarget.bed -o control500-cnn/${SAMPLE}.antitargetcoverage.cnn
done <ControlList.txt


# Create a normal reference with all normal samples '.cnn' files
cnvkit.py reference control500-cnn/controls-BLYMv2/*.{,anti}targetcoverage.cnn --fasta hg19.fa -o my_reference500.cnn

# Create the cnr/cns/graphs for each tumor sample '.cnn' files
for i in tumor500-cnn/samtools-deduped-bam/*.antitargetcoverage.cnn
do
#   Trim the string to get a root name of the sample
  SAMPLE="$(echo $i | sed 's/.antitargetcoverage.cnn//g')"
  ##  Using samtools-deduped on-target and off-target data
  # For each tumor sample...
  if [ ! -f ${SAMPLE}.cnr ]; then
    echo "Working on tumor sample: $SAMPLE"
    cnvkit.py fix ${SAMPLE}.targetcoverage.cnn ${SAMPLE}.antitargetcoverage.cnn my_reference500.cnn -o ${SAMPLE}.cnr
    cnvkit.py segment ${SAMPLE}.cnr -o ${SAMPLE}.cns
    # Optionally, with --scatter and --diagram
    cnvkit.py scatter ${SAMPLE}.cnr -s ${SAMPLE}.cns -o ${SAMPLE}-scatter.pdf
    cnvkit.py diagram ${SAMPLE}.cnr -s ${SAMPLE}.cns -o ${SAMPLE}-diagram.pdf
  fi
done


# Loop over all *.cns and *.cnr in the results dir of tumors for making the calls
for i in tumor500-cnn/samtools-deduped-bam/*.antitargetcoverage.cnn
do
  # Trim the string to get a root name of the sample
  SAMPLE="$(echo $i | sed 's/.antitargetcoverage.cnn//g')"
  ##  Using samtools-deduped on-target and off-target data
  # For each tumor sample cn-segment...
  if [ ! -f ${SAMPLE}.call.cns ]; then
    echo "Call on cn-segment tumor sample: $SAMPLE"
    cnvkit.py call ${SAMPLE}.cns
    # Move the call file to the result directory
    mv *.call.cns tumor500-cnn/samtools-deduped-bam/
  fi
done
