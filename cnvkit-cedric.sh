#cnvkit.py access hg19.fa -o access.hg19.bed
#cnvkit.py autobin ./samtools-deduped-bam/*.bam -t baits500.bed -g access.hg19.bed


# Using baits selector with add500bp
while read p; do
 SAMPLE="$(echo $p | sed 's/.cfDNA.sorted.samtools-deduped.sorted.bam//g')"  
 echo "$SAMPLE"
 cnvkit.py coverage $p baits500.target.bed -o tumor500-cnn/${SAMPLE}.targetcoverage.cnn
 cnvkit.py coverage $p baits500.antitarget.bed -o tumor500-cnn/${SAMPLE}.antitargetcoverage.cnn
done <SampleList.txt

while read p; do
 SAMPLE="$(echo $p | sed 's/-c1_cfDNA.sorted.samtools-deduped.sorted.bam//g')"
 echo "$SAMPLE"
 cnvkit.py coverage $p baits500.target.bed -o control500-cnn/${SAMPLE}.targetcoverage.cnn# cnvkit.py coverage $p baits500.antitarget.bed -o control500-cnn/${SAMPLE}.antitargetcoverage.cnn
 cnvkit.py coverage $p baits500.antitarget.bed -o control500-cnn/${SAMPLE}.antitargetcoverage.cnn
done <ControlList.txt


# With all normal samples...
#cnvkit.py reference control-cnn/controls-BLYMv2/*.{,anti}targetcoverage.cnn --fasta hg19.fa -o my_reference500.cnn

# For each tumor sample...
#for i in tumor500-cnn/cfDNA.sorted.samtools-deduped.sorted.bam/*.antitargetcoverage.cnn
#do
#   Trim the string to get a root name of the sample
#  SAMPLE="$(echo $i | sed 's/.antitargetcoverage.cnn//g')"
  ##  Using samtools-deduped on-target and off-target data
  # For each tumor sample...
#  if [ ! -f ${SAMPLE}.cnr]; then
#    echo "Working on tumor sample: $SAMPLE"
#    cnvkit.py fix ${SAMPLE}.targetcoverage.cnn ${SAMPLE}.antitargetcoverage.cnn my_reference500.cnn -o ${SAMPLE}.cnr
#    cnvkit.py segment ${SAMPLE}.cnr -o ${SAMPLE}.cns
    # Optionally, with --scatter and --diagram
#    cnvkit.py scatter ${SAMPLE}.cnr -s ${SAMPLE}.cns -o ${SAMPLE}-scatter.pdf
#    cnvkit.py diagram ${SAMPLE}.cnr -s ${SAMPLE}.cns -o ${SAMPLE}-diagram.pdf
#  fi
#done


# Loop over all *.cns and *.cnr in the results dir of tumors for making the calls
#for i in tumor500-cnn/samtools-deduped-bam/*.antitargetcoverage.cnn
#do
  # Trim the string to get a root name of the sample
  SAMPLE="$(echo $i | sed 's/.antitargetcoverage.cnn//g')"
  ##  Using samtools-deduped on-target and off-target data
  # For each tumor sample cn-segment...
#  if [ ! -f ${SAMPLE}.call.cns ]; then
#    echo "Call on cn-segment tumor sample: $SAMPLE"
#    cnvkit.py call ${SAMPLE}.cns
    # Move the call file to the result directory
#    mv *.call.cns ${SAMPLE}.call.cns
#  fi
  # For each tumor sample cn-region...
#  if [ ! -f ${SAMPLE}.call.cnr ]; then
#    echo "Call on cn-region tumor sample: $SAMPLE"
#    cnvkit.py call ${SAMPLE}.cnr
    # Move the call file to the result directory
#    mv *.call.cnr ${SAMPLE}.call.cnr
#  fi
#done
