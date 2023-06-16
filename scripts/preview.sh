#!/bin/bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/_colors.sh"


__help="$GREY
  ▐               ▐     ▜             ▐  
  ▜▀ ▛▚▀▖▌ ▌▚▗▘▄▄▖▜▀ ▞▀▖▐ ▞▀▖▛▀▖▞▀▖▙▀▖▜▀ 
  ▐ ▖▌▐ ▌▌ ▌▗▚    ▐ ▖▛▀ ▐ ▛▀ ▙▄▘▌ ▌▌  ▐ ▖
   ▀ ▘▝ ▘▝▀▘▘ ▘    ▀ ▝▀▘ ▘▝▀▘▌  ▝▀ ▘   ▀ 
        v0.1$RESET


  Search for windows/sessions, use up/down keys to select a window
  $BLUE
  $RESET
  RETURN    Go to selected $UNDERLINE""window$RESET (add a named window if 0 matches)

  CTRL-x    Cut selected $UNDERLINE""window$RESET 
  CTRL-p    Paste the cut $RED✂ $RESET window

  CTRL-t    Take active $ORANGE""window$RESET, and put it next to selected $UNDERLINE""window$RESET
  CTRL-g    Grab selected $UNDERLINE""window$RESET and pull it next to active $ORANGE""window$RESET 

  CTRL-l    Clear search query and reset
  CTRL-w    Wipe search query
    
  CTRL-r    Reload list of windows
  CTRL-f    Refresh the overview of panes

  CTRL-]    Add a window, named with the search query
  CTRL-e    Rename $UNDERLINE""window$RESET (refresh names with CTRL-r)
  DELETE    Delete selected $UNDERLINE""window$RESET

  ESCAPE    Exit
"
# tab         Select next pane
# shift-tab   Mark selected pane

# $ORANGE home window$RESET = the window you were in when you launched tmux-teleport

# $GREYLIGHT_BG""window$RESET = the window selected on the left

window_id=$(echo $1 | awk '{print $1}')
window_name=$(echo $1 | awk '{print $4}')

case "$1" in
	*help)
		echo "$__help"
		exit
		;;
esac




if [[ ! $window_id =~ ^-?[0-9]+$ ]]; then
	sleep 0.25
	$CURRENT_DIR/center.sh
	exit
fi

panes=$(tmux list-panes -t "@$window_id" -F "#{pane_id} #{pane_current_command} #{pane_current_path} \
	                                         #{pane_width} #{pane_pid} #{pane_tty} #{pane_active} \
	                                         #{pane_title} #{pane_height} #{pane_marked}")
									
CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# default_title=$(hostname -s)
TTY_BG="$(tput setab 16)"

pane_bf="$BLACK_BG$GREY" # dynamically changed
pane_border_bf="$BLACK_BG$GREY" # dynamically changed

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
	h=$(echo $HOME | sed 's|/|\\/|g') 
	path=$(echo "$path" | sed "s/$h/~/")

	i=$((i+1)) 

	if [ $active -eq '1' ]; then
		pane_bf="$BLACK_BG$WHITE"
	else
		pane_bf="$BLACK_BG$GREY"
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
			| $CURRENT_DIR/pad.sh $full_width \
			| sed  "s/^/  $pane_border_bf│ /" \
			| sed "s/$/$pane_border_bf│$RESET/"
	else
		pane_lines_n=$(echo "$pane_contents" | wc -l)
		lines_per_half=$((-1 + (pane_lines_n + 1) / 2 ))

		pane_top=$(echo "$pane_contents" | uniq | head -$lines_per_half | head -5 \
			| $CURRENT_DIR/pad.sh $full_width \
			| sed  "s/^/  $pane_border_bf│ /" \
			| sed "s/$/│$RESET/")
		pane_bottom=$(echo "$pane_contents" | uniq | tail -$lines_per_half | tail -5 \
			| $CURRENT_DIR/pad.sh $full_width \
			| sed  "s/^/  $pane_border_bf│ /" \
			| sed "s/$/│$RESET/")
		divider_tiles=$(printf "~%.0s" $(seq 1 $(($padded_width))))
		pane_divider="  $pane_border_bf┆$GREY$divider_tiles$pane_border_bf┆"

		echo "$pane_top
$pane_divider
$RESET$pane_bottom"
	fi

	# bottom border
	echo -n "  $pane_border_bf$blchar"
	printf "─%.0s" $(seq 1 $(($padded_width)))
	echo "$brchar$RESET"

	# context line
	echo -n "    $BLUE$path$RESET "
	pstree -C age $pid | sed "s/^/ /" | sed 's/\x1B\[[0-9;]\{1,\}[A-Za-z]//g'
	echo

	# echo # "       $cmd  $pid  "
	# tput rc 1; tput el
	# | perl -pe "s/\Q${RESET}\E/$BLACK/g" \
done <<< "$panes"
