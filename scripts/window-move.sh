#!/bin/bash 

# TODO
# - fix renumbering tmux move-window -r or 'set -g renumber-windows off' off/on

target_index=$2

target_session="$3"

# choose a or b
# A for testing in current session
src_index=$1
src_id=$(tmux display-message -p -t ":$src_index" -F '#{window_id}')

# B call from fzf-tmux-portal
# src_id_raw=$1
# src_id="@$src_id"
# src_index=$(tmux display-message -p -t "$src_id" -F '#{window_index}')


target_id_raw=$(echo $1 | awk '{print $1}')
target_id="@$target_id_raw"
target_index=$(tmux display-message -p -t "$target_id" -F '#{window_index}')
target_session=$(tmux display-message -p -t "$target_id" -F '#{session_name}')

src_id_raw=$(tmux show-environment -g cut_window_id | awk -F "=" '{print $2}')
src_id="@$src_id_raw"


echo " $target_id_raw $target_id $target_index $target_session $src_id " >> ~/foo


current_index=$(tmux display-message -p -F '#{window_index}')
current_id=$(tmux display-message -p -F '#{window_id}')

if tmux move-window -d -s "$src_id" -t $target_session:$((target_index+1)) 2>/dev/null; then
	echo ok > ~/foo
else
	echo no ok > ~/foo
	windows=$(tmux list-windows -t "$target_session" | awk -F ':' '{print $1}' | sort -nr)

	# Move the windows with the highest index to index + 1, repeat all the way to and including the target_index window
	for win in $windows; do
		if [[ $win -gt $target_index ]]; then
			d='-d'
			[[ $win == $current_index ]] && d='' # if current window don't use -d
			tmux move-window $d -s $target_session:$win -t $target_session:$((win + 1)) 2>/dev/null
		fi
		# sleep 1
	done

	# d='-d'
	# [[ $src_index != $current_index ]] && d='' # if current window don't use -d

	# echo "$src_index  $current_index"
	# Now move the window again
	tmux move-window $d -s "$src_id" -t $target_session:$((target_index+1))
	# tmux display-message "moved $src_id -> $target_index+1"
fi

tmux select-window -t "$current_id" # todo: shouldn't need this
tmux move-window -r

tmux set-environment -g -r cut_window_id

echo done > ~/foo
