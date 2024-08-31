#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$CURRENT_DIR/_colors.sh"

# LC_CTYPE=C
LANG=C # workaround for "sed: RE error: illegal byte sequence" error on macOS

__help="$GREY                                    ▗▄▖
  ▐▌                       ▐▌       ▝▜▌                       ▐▌
 ▐███ ▐█▙█▖▐▌ ▐▌▝█ █▘     ▐███  ▟█▙  ▐▌   ▟█▙ ▐▙█▙  ▟█▙  █▟█▌▐███
  ▐▌  ▐▌█▐▌▐▌ ▐▌ ▐█▌       ▐▌  ▐▙▄▟▌ ▐▌  ▐▙▄▟▌▐▛ ▜▌▐▛ ▜▌ █▘   ▐▌
  ▐▌  ▐▌█▐▌▐▌ ▐▌ ▗█▖  ██▌  ▐▌  ▐▛▀▀▘ ▐▌  ▐▛▀▀▘▐▌ ▐▌▐▌ ▐▌ █    ▐▌
  ▐▙▄ ▐▌█▐▌▐▙▄█▌ ▟▀▙       ▐▙▄ ▝█▄▄▌ ▐▙▄ ▝█▄▄▌▐█▄█▘▝█▄█▘ █    ▐▙▄
   ▀▀ ▝▘▀▝▘ ▀▀▝▘▝▀ ▀▘       ▀▀  ▝▀▀   ▀▀  ▝▀▀ ▐▌▀▘  ▝▀▘  ▀     ▀▀
       v0.3.4                                 ▐▌
$RESET

	return   Go to ${GREY_BG}window$RESET or run ${BLUE}action$RESET

	ctrl n   New window, named with the search text
	ctrl \   Rename ${GREY_BG}window$RESET 
	delete   Delete ${GREY_BG}window$RESET

	ctrl o   Cut ${GREY_BG}window$RESET 
	ctrl p   Paste the ${RED}cut window$RESET
	ctrl g   Grab ${GREY_BG}window$RESET and pull it next to the ${ORANGE}current window$RESET 
	ctrl t   Throw the ${ORANGE}current window$RESET next to ${GREY_BG}window$RESET

	ctrl l   Clear search text and reset selection
	ctrl w   Delete last word of search text

	ctrl f   Refresh ${GREY_BG}window$RESET preview
	ctrl r   Reload list of windows

	escape   Exit


    ${GREEN}ctrl-w (or backspace) to leave this screen
"
# tab         Select next pane
# shift-tab   Mark selected pane

# $ORANGE home window$RESET = the window you were in when you launched tmux-teleport

# ${GREYLIGHT_BG}window$RESET = the window selected on the left

window_id=$(echo "$1" | awk '{print $1}')
window_name=$(echo "$1" | awk '{print $4}')

case "$1" in
	*help)
		echo "$__help"
		exit
		;;
esac

if [[ ! $window_id =~ ^-?[0-9]+$ ]]; then
	sleep 0.25
	"$CURRENT_DIR"/center.sh
	exit
fi

panes=$(tmux list-panes -t "@$window_id" -F "#{pane_id} #{pane_current_command}  \
	                                         #{pane_width} #{pane_pid} #{pane_tty} #{pane_active} \
	                                         #{pane_title} #{pane_height} #{pane_marked} \
											 #{pane_current_path}")
type pstree > /dev/null
HAVE_PSTREE=$?

# default_title=$(hostname -s)

pane_bf="$BLACK_BG$GREY" # dynamically changed
pane_border_bf="$BLACK_BG$GREY" # dynamically changed

# lchar='│'
# linechars="─"
tlchar='┌'; trchar='┐'
blchar='└'; brchar='┘'
lmargin='   '

echo

i=0
while IFS= read -r pane; do
	read -r id cmd w pid tty active title h is_marked path <<< "$pane"
	raw_id="${id:1}"
	full_width=$((w-1))
	padded_width=$((full_width+1))
	h=$(echo "$HOME" | sed 's|/|\\/|g') 
	path=$(echo "$path" | sed "s/$h/~/")

	i=$((i+1)) 

	if [ "$active" -eq '1' ]; then
		pane_bf="$BLACK_BG$WHITE"
	else
		pane_bf="$BLACK_BG$GREY"
	fi
	pane_border_bf="$pane_bf"

	[ "$is_marked" = '1' ] && pane_border_bf="$MARKED_FG"	

	# top border
	echo -n "  $pane_border_bf$tlchar"
	printf "─%.0s" $(seq 1 $((padded_width)))
	echo "$trchar$RESET"

	pane_contents=$(tmux capture-pane -p -N -t "$id") # -e for color, broken: can't filter out $RESET
	pane_lines_uniq_n=$(echo "$pane_contents" | uniq | wc -l)

	if [[ $pane_lines_uniq_n -lt 10 ]]; then
		echo "$pane_contents" | uniq \
			| "$CURRENT_DIR"/pad.sh $full_width \
			| sed  "s/^/  $pane_border_bf│ /" \
			| sed "s/$/$pane_border_bf│$RESET/"
	else
		pane_lines_n=$(echo "$pane_contents" | wc -l)
		lines_per_half=$((-1 + (pane_lines_n + 1) / 2 ))

		pane_top=$(echo "$pane_contents" | uniq | head -$lines_per_half | head -5 \
			| "$CURRENT_DIR"/pad.sh $full_width \
			| sed  "s/^/  $pane_border_bf│ /" \
			| sed "s/$/│$RESET/")
		pane_bottom=$(echo "$pane_contents" | uniq | tail -$lines_per_half | tail -5 \
			| "$CURRENT_DIR"/pad.sh $full_width \
			| sed  "s/^/  $pane_border_bf│ /" \
			| sed "s/$/│$RESET/")
		divider_tiles=$(printf "~%.0s" $(seq 1 $((padded_width))))
		pane_divider="  $pane_border_bf┆$GREY$divider_tiles$pane_border_bf┆"

		echo "$pane_top
$pane_divider
$RESET$pane_bottom"
	fi

	# bottom border
	echo -n "  $pane_border_bf$blchar"
	printf "─%.0s" $(seq 1 $((padded_width)))
	echo "$brchar$RESET"

	# context line
	echo -n "    $BLUE$path$RESET "
	width=${#path}
	if [ $HAVE_PSTREE -eq 0 ]; then 
		pstree "$pid" | head -1
		pad=$(printf "%${width}s")
		pstree "$pid" | tail -n +2 | sed "s/^/     $pad/g"
	fi
	echo

	# echo # "       $cmd  $pid  "
	# tput rc 1; tput el
	# | perl -pe "s/\Q${RESET}\E/$BLACK/g" \
done <<< "$panes"
