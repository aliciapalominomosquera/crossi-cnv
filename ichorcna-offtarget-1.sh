# First step, generate the '.bam' and '.bai' files with only the off-target regions.
# Directory for ichorCNA computations
WRKDIR=$PWD
# Directory providing bam files data
DATADIR="/drive3/aliciapm/cnv-project/apm-cnv-ali/cedric/samtools-deduped-bam"
# Reference bed file for targeted regions from HEMESTAMP (ichorCNA performs better with add500bp selector).
REFBED="/drive3/cfDNA/selectors/BLYM_v2_AUG2021.add500bp.bed"
# Output directory 
OUTDIR="/drive3/aliciapm/cnv-project/apm-cnv-ali/cedric/on-off-files"


# Loop over the bam files labels to create the corresponding on-target and off-target files
for i in ${DATADIR}/*.bam
do
    SAMPLE="$(echo $i | sed 's/.cfDNA.sorted.samtools-deduped.sorted.bam//g')"
    echo "$SAMPLE" 
# Run samtools to get offtarget bam file.
    echo "samtools view -b -L $REFBED -o ${SAMPLE}.ontarget.bam -U ${SAMPLE}.offtarget.bam ${i}"
    samtools view -b -L $REFBED -o ${SAMPLE}.ontarget.bam -U ${SAMPLE}.offtarget.bam ${i}
    # Run samtools to get bam index
    #echo "samtools index ${OUTDIR}/${SAMPLE}.offtarget.bam"
    samtools index ${SAMPLE}.offtarget.bam
done
