#!/bin/bash

EUTILS="http://eutils.ncbi.nlm.nih.gov/entrez/eutils/"
ID=$1;
DATABASE=${2:-nuccore}
RETTYPE=${3:-fasta}
RETMODE=${4:-text}

# echo "$EUTILS/efetch.fcgi?db="$DATABASE"&id="$ID"&rettype="$RETTYPE"&retmode="$RETMODE
printf "%-20s %15s %20s " "[$DATABASE $RETTYPE]" $ID $ID.${RETTYPE:0:2}
wget --quiet -O $ID.${RETTYPE:0:2} "$EUTILS/efetch.fcgi?db="$DATABASE"&id="$ID"&rettype="$RETTYPE"&retmode="$RETMODE;

# fail
[ $? -gt 0 ] && { printf "%15s %6s\n" - FAIL; exit 1; }

# emtpy
FILESIZE=$(stat -c%s $ID.${RETTYPE:0:2});
[ $FILESIZE -lt 2 ] && { rm  $ID.${RETTYPE:0:2};  printf "%15s  %6s\n" $FILESIZE EMPTY; exit 1; }

# ok
printf "%15s %6s\n" $FILESIZE ok;
