#!/bin/bash

# reliably detect bin
pushd `dirname $0` > /dev/null
BIN=`pwd`
popd > /dev/null

DATE=`date +%Y%m%d`
DIR=plastids-$DATE;
mkdir $DIR || exit 1;

cd $DIR;

ACC_LIST_URL="http://www.ncbi.nlm.nih.gov/genomes/GenomesGroup.cgi?opt=plastid&taxid=2759&cmd=download1";
ACC_LIST=accession.tsv;

# tax=eukaryotes
echo -n 'Retrieving accessions list .. '
wget --quiet -O $ACC_LIST $ACC_LIST_URL;
[[ $? -gt 0 ]] && { echo "FAILED" 1>&2; exit 1; };
echo 'ok';

# retrieve files
TC=`wc -l <$ACC_LIST`;
echo "Retrieving $TC records .. ";
C=0;
while read LINE; do
    C=$(( $C + 1 ));
    ACC=${LINE:0:-1}; # get rid of trailing \n
    echo "[$C/$TC]";
    $BIN/ncbi-efetch.sh $ACC nuccore fasta
    $BIN/ncbi-efetch.sh $ACC nuccore gb
done < $ACC_LIST;
echo ".. Done";

