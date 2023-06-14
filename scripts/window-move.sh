#!/bin/bash 
# TODO
# - fix renumbering tmux move-window -r or 'set -g renumber-windows off' off/on

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
LOG="/tmp/tmux-teleport.log"

src_id_raw=$1
target_index=$2
target_session="$3"

src_id="@$src_id_raw"
src_index=$(tmux display-message -p -t "$src_id" -F '#{window_index}')

# choose a or b
# A for testing in current session
# src_index=$1
# src_id=$(tmux display-message -p -t ":$src_index" -F '#{window_id}')

# B call from fzf-tmux-portal

# target_id_raw=$(echo $1 | awk '{print $1}')
# target_id="@$target_id_raw"
# target_index=$(tmux display-message -p -t "$target_id" -F '#{window_index}')
# target_session=$(tmux display-message -p -t "$target_id" -F '#{session_name}')

# src_id_raw=$(tmux show-environment -g cut_window_id | awk -F "=" '{print $2}')
# src_id="@$src_id_raw"


current_index=$(tmux display-message -p -F '#{window_index}')
current_id=$(tmux display-message -p -F '#{window_id}')

last_window_id=$(tmux list-windows -F "#{window_id} #{window_last_flag}" | grep '1$' | cut -d' ' -f1)

this_session=$(tmux display-message -p '#{session_name}')

# echo " $target_id_raw $target_id $target_index $target_session $src_id ~$this_session" >> $LOG
echo "$src_id => $target_session:$target_index  ~$this_session" >> $LOG

# echo "$1" >> $LOG

if [[ "$this_session" != "$target_session" ]]; then
	# there is a bug in tmux. new-windows can be -appended but often move-windows cannot, so:
	index=$(tmux new-window -n tmp -d -a -P -F '#{window_index}' -t $target_session:$target_index) # append a new one, get its index
	tmux move-window -k -d -s "$src_id" -t $target_session:$index
	tmux move-window -r
	# this only works when moving a window to a session you are not in, therefore
else
	if tmux move-window -d -s "$src_id" -t $target_session:$((target_index+1)) 2>/dev/null; then
	 	echo ok >> $LOG
	 else
		# tmux move-window -a -d -s "$src_id" -t :$index

		# 1. find first free slot
		gap=$(tmux list-windows -F "#{window_index}" | $CURRENT_DIR/first-gap.sh $target_index)
		# 2. if pos > target+1 iterate back moving each window forward 1
		for ((i=$gap-2; i>$target_index; i--)); do
			b=$((i + 1))
			tmux move-window -d -s "$target_session:$i" -t "$target_session:$b"
			echo tmux move-window -d -s "$target_session:$i" -t "$target_session:$b" >> $LOG
	 	done
		# 3. insert window in target+1
		tmux move-window -d -s "$src_id" -t $target_session:$((target_index+1))
		echo "tmux move-window -d -s $src_id -t $target_session:$((target_index+1))" >> $LOG

	 	# echo "gap @ $gap - no ok" >> $LOG

	# 	windows=$(tmux list-windows -t "$target_session" | awk -F ':' '{print $1}' | sort -nr)

	# 	# Move the windows with the highest index to index + 1, repeat all the way to and including the target_index window
	# 	for win in $windows; do
	# 		if [[ $win -gt $target_index ]]; then
	# 			d='-d'
	# 			[[ $win == $current_index ]] && d='' # if current window don't use -d
	# 			tmux move-window $d -s $target_session:$win -t $target_session:$((win + 1)) 2>/dev/null
	# 		fi
	# 		sleep 0.1
	# 	done

	# 	d='-d'
	# 	[[ $src_index != $current_index ]] && d='' # if current window don't use -d

	# 	# now the window should move
	# 	tmux move-window $d -s "$src_id" -t $target_session:$((target_index+1))
	# 	echo "moved $src_id -> $target_index+1" >> $LOG
	fi

	# echo "switching to $last_window_id window" >> $LOG 
	# tmux select-window -t "$last_window_id" # switch to the home window
	# tmux select-window -t "$current_window_id" # and then back to teleport
	# tmux move-window -r
fi

tmux set-environment -g -r cut_window_id

echo done >> $LOG

