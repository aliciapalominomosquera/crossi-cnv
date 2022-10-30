ICHORDIR="/drive3/aliciapm/ichorCNA"
WRKDIR=$PWD
# Loop over offtarget bam files of the tumor samples.
mkdir ${WRKDIR}/results-ichorcna
for wigfile in ${WRKDIR}/samtools-deduped-bam/*.offtarget.bam.wig
do
  # Weird trimming using sed to extract the hemestamp label
  TESTID="$(echo ${wigfile} | sed 's/.*Sample_//g' | sed 's/.offtarget.*//g')"
  if [ ! -d ${WRKDIR}/results-ichorcna/${TESTID} ]; then
    # Run ichorcna to get final CNA results.
    Rscript ${ICHORDIR}/scripts/runIchorCNA.R --id $TESTID --WIG $wigfile --normal "c(0.5,0.6,0.7,0.8,0.9)" --maxCN 5 --gcWig   ${ICHORDIR}/inst/extdata/gc_hg19_1000kb.wig --mapWig ${ICHORDIR}/inst/extdata/map_hg19_1000kb.wig --centromere ${ICHORDIR}/inst/extdata/GRCh37.p13_centromere_UCSC-gapTable.txt --normalPanel ${WRKDIR}/ichor-reference-normal_median.rds --includeHOMD False --chrs "c(1:22, \"X\")" --chrTrain "c(1:22)" --estimateNormal true --estimatePloidy True --scStates "c(1,3)" --txnStrength 1000 --outDir ${WRKDIR}/results-ichorcna
  fi
done
