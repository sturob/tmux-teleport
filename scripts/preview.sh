#!/bin/bash

RESET=$(tput sgr0)
BLUEFG=$(tput setaf 4)

__help="
▐               ▐     ▜             ▐  
▜▀ ▛▚▀▖▌ ▌▚▗▘▄▄▖▜▀ ▞▀▖▐ ▞▀▖▛▀▖▞▀▖▙▀▖▜▀ 
▐ ▖▌▐ ▌▌ ▌▗▚    ▐ ▖▛▀ ▐ ▛▀ ▙▄▘▌ ▌▌  ▐ ▖
 ▀ ▘▝ ▘▝▀▘▘ ▘    ▀ ▝▀▘ ▘▝▀▘▌  ▝▀ ▘   ▀ 

  $BLUEFG
  DEFINITIONS
  $RESET
  Your home window is where you launched teleporter from, it has * next to it.

  The highlighted window is the one you've selected on the left.

  $BLUEFG
  CORE KEY BINDINGS
  $RESET
  enter       Go to selected window

  ctrl-x      Cut window

  ctrl-p      Paste window

  ctrl-t      Teleport your home window next to the selected window

  ctrl-g      Grab selected window and pull it next to your home window

  esc         Exit if no search, otherwise clear search and reset highlighted window


  $BLUEFG
  EXTRA KEY BINDINGS
  $RESET
  ctrl-e    Rename highlighted window (needs tmux > 3.2)

  ctrl-r    Reload list of windows
 
  ctrl-f    Refresh the window overview

  tab         Select next pane

  shift-tab   Select previous pane
"

window_id=$(echo $1 | awk '{print $1}')
window_name=$(echo $1 | awk '{print $4}')

case "$1" in
	*help)
		echo "$__help"
		exit
		;;
esac

if [[ ! $window_id =~ ^-?[0-9]+$ ]]; then
	exit
fi

# toilet -tf smmono9 $window_name

panes=$(tmux list-panes -t "@$window_id" -F "#{pane_id} #{pane_current_command} #{pane_current_path} \
	                                         #{pane_width} #{pane_pid} #{pane_tty} #{pane_active} \
	                                         #{pane_title} #{pane_height} #{pane_marked}")

# default_title=$(hostname -s)
TTY_BG="$(tput setab 16)"
PANEID_COLOR="$(tput setaf 8)"
PATH_COLOR="$(tput setaf 4)"
# ACTIVE_COLOR="$(tput setaf 3)"
MARKED_FG=$(tput setaf 5)
WHITEFG=$(tput setaf 15)
GREYFG=$(tput setaf 8)
BLACKBG="$(tput setab 16)"

pane_bf="$BLACKBG$GREYFG" # dynamically changed
pane_border_bf="$BLACKBG$GREYFG" # dynamically changed

lchar='│'
tlchar='┌'; trchar='┐'
linechars="─"
blchar='└'; brchar='┘'
lmargin='   '
echo

i=0
while IFS= read -r pane; do
	read -r id cmd path w pid tty active title h is_marked<<< "$pane"
	raw_id="${id:1}"
	full_width=$(($w-1))
	padded_width=$(($full_width+1))
	path=$(echo "$path" | sed 's/\/home\/stu/~/')

	i=$((i+1)) 

	if [ $active -eq '1' ]; then
		pane_bf="$BLACKBG$WHITEFG"
	else
		pane_bf="$BLACKBG$GREYFG"
	fi
	pane_border_bf="$pane_bf"

	[ "$is_marked" = '1' ] && pane_border_bf="$MARKED_FG"	

	# top border
	echo -n "  $pane_border_bf$tlchar"
	printf "─%.0s" $(seq 1 $(($padded_width)))
	echo "$trchar$RESET"

	pane_contents=$(tmux capture-pane -p -N -t "$id") # -e for color, broken: can't filter out $RESET
	pane_lines_uniq_n=$(echo "$pane_contents" | uniq | wc -l)

	if [[ $pane_lines_uniq_n -lt 10 ]]; then
		echo "$pane_contents" | uniq \
			| ~/.bin-sturob/fzf-tmux-portal/pad.sh $full_width \
			| sed  "s/^/  $pane_border_bf│ /" \
			| sed "s/$/$pane_border_bf│$RESET/"
	else
		pane_lines_n=$(echo "$pane_contents" | wc -l)
		lines_per_half=$((-1 + (pane_lines_n + 1) / 2 ))

		pane_top=$(echo "$pane_contents" | uniq | head -$lines_per_half | head -5 \
			| ~/.bin-sturob/fzf-tmux-portal/pad.sh $full_width \
			| sed  "s/^/  $pane_border_bf│ /" \
			| sed "s/$/│$RESET/")
		pane_bottom=$(echo "$pane_contents" | uniq | tail -$lines_per_half | tail -5 \
			| ~/.bin-sturob/fzf-tmux-portal/pad.sh $full_width  \
			| sed  "s/^/  $pane_border_bf│ /" \
			| sed "s/$/│$RESET/")
		divider_tiles=$(printf "~%.0s" $(seq 1 $(($padded_width))))
		pane_divider="  $pane_border_bf┆$GREYFG$divider_tiles$pane_border_bf┆"

		echo "$pane_top
$pane_divider
$RESET$pane_bottom"
	fi

	# bottom border
	echo -n "  $pane_border_bf$blchar"
	printf "─%.0s" $(seq 1 $(($padded_width)))
	echo "$brchar$RESET"

	# context line
	echo -n "    $PATH_COLOR$path$RESET "
	pstree -C age $pid | sed "s/^/ /" | sed 's/\x1B\[[0-9;]\{1,\}[A-Za-z]//g'
	echo

	# echo # "       $cmd  $pid  "
	# tput rc 1; tput el
	# | perl -pe "s/\Q${RESET}\E/$BLACK/g" \
done <<< "$panes"
