#!/bin/bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$CURRENT_DIR/_colors.sh"

echo "$INVISIBLE_BRAILLE$BLACK =  $BLUE+ new window"

# buffering necessary to stop cursor changing position on reload
$CURRENT_DIR/list.sh "$1" | awk 'NF==0{for(i=1;i<=j;i++) print a[i]; print ""; j=0} NF!=0{a[++j]=$0} END{for(i=1;i<=j;i++) print a[i]}'

# awk 'NF==0{for(i=1;i<=j;i++) print a[i]; j=0} NF!=0{a[++j]=$0} END{for(i=1;i<=j;i++) print a[i]}'
# awk '{a[NR]=$0} END{for(i=1;i<=NR;i++) print a[i]}'
