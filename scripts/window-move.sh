#!/usr/bin/env bash 
# TODO
# - fix renumbering tmux move-window -r or 'set -g renumber-windows off' off/on

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
LOG="/tmp/tmux-teleport.log"

src_id_raw=$1
target_index=$2
target_session="$3"

src_id="@$src_id_raw"
src_index=$(tmux display-message -p -t "$src_id" -F '#{window_index}')

current_window_index=$(tmux display-message -p -F '#{window_index}')
current_window_id=$(tmux display-message -p -F '#{window_id}')

this_session=$(tmux display-message -p '#{session_name}')

echo "$src_id => $target_session:$target_index  ~$this_session" >> $LOG

if [[ "$this_session" != "$target_session" ]]; then
	# tmux bug - new-windows can be -a ppended but often move-windows cannot, so:
	index=$(tmux new-window -n tmp -d -a -P -F '#{window_index}' -t $target_session:$target_index) # append a new one, get its index
	tmux move-window -k -d -s "$src_id" -t $target_session:$index # overwrite new window
	# this only works when moving a window to a session you are not in, if you are in the $target_session
	# then new-window doesn't honor the -d flag, therefore:
else
	if tmux move-window -d -s "$src_id" -t $target_session:$((target_index+1)) 2>>$LOG; then
	 	echo there was a gap, move ok >> $LOG
		tmux select-window -t "$current_window_id" >> $LOG # and then back to teleport
	else
		# find first free slot
		gap=$(tmux list-windows -F "#{window_index}" | $CURRENT_DIR/first-gap.sh $target_index)
		# if pos > target+1 iterate back moving each window forward 1
		for ((i=$gap-1; i>$target_index; i--)); do
			b=$((i + 1))
			# sleep 1
			tmux move-window -d -s "$target_session:$i" -t "$target_session:$b" >> $LOG
			echo "shuffle $i -> $b" >> $LOG
	 	done
		# insert window in target+1
		tmux move-window -d -s "$src_id" -t $target_session:$((target_index+1)) >> $LOG
		echo XX "tmux move-window -d -s $src_id -t $target_session:$((target_index+1))" >> $LOG
		
		# if what
		# tmux select-window -t "$last_window_id" >> $LOG 
		tmux select-window -t "$current_window_id" >> $LOG # switch to the home window
	fi
fi

tmux set-environment -g -u cut_window_id

echo done >> $LOG
