#!/bin/bash 

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
LOG="/tmp/tmux-teleport.log"

first_col=$(echo $1 | awk '{print $3}');

current_window_id=$(tmux display-message -p -F '#{window_id}')

src_id_raw=$(tmux show-environment -g cut_window_id | awk -F "=" '{print $2}')
src_id="@$src_id_raw"

if [[ $first_col == '$' ]]; then
	echo paste-to-new-session >> $LOG
	current_session_id=$(tmux display-message -p -F '#{session_id}')
	new_session_id=$(tmux new-session -d -P -F "#{session_id}")
	echo "a: $current_session_id  b: $new_session_id" >> $LOG
	first_window_id=$(tmux list-windows -t $new_session_id -F '#{window_id}' | head -n 1)
	tmux move-window -s $src_id -t $new_session_id >> $LOG
	tmux kill-window -t $first_window_id
	tmux switch-client -t $new_session_id >> $LOG
	exit
else
	echo standard-new-session >> $LOG
fi

target_id_raw=$(echo $1 | awk '{print $1}')
target_id="@$target_id_raw"

target_index=$(tmux display-message -p -t "$target_id" -F '#{window_index}')
target_session=$(tmux display-message -p -t "$target_id" -F '#{session_name}')

this_session=$(tmux display-message -p '#{session_name}')

$CURRENT_DIR/window-move.sh $src_id_raw $target_index $target_session

if [[ "$src_id" == "$current_window_id" && "$this_session" != "$target_session" ]]; then # we're moving current cross-session
	tmux select-window -t "$current_window_id"
	tmux switch-client -t "$target_session"
fi
