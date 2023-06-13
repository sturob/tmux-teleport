#!/bin/bash

INVISIBLE_BRAILLE="⠀"
GREY=$(tput setaf 8)
echo "$GREY$INVISIBLE_BRAILLE =   + new window"

# reduce flickering by buffering
~/.bin-sturob/fzf-tmux-portal/list.sh "$1" | awk 'NF==0{for(i=1;i<=j;i++) print a[i]; print ""; j=0} NF!=0{a[++j]=$0} END{for(i=1;i<=j;i++) print a[i]}'

# awk 'NF==0{for(i=1;i<=j;i++) print a[i]; j=0} NF!=0{a[++j]=$0} END{for(i=1;i<=j;i++) print a[i]}'
# awk '{a[NR]=$0} END{for(i=1;i<=NR;i++) print a[i]}'
