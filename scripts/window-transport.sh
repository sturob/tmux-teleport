#!/bin/bash

LOG="/tmp/tmux-teleport.log"
CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# if target is an action $ new session

first_col=$(echo $1 | awk '{print $3}');

current_window_id=$(tmux display-message -p -F '#{window_id}')

if [[ $first_col == '$' ]]; then
	echo throwing-to-new-session >> $LOG
	current_session_id=$(tmux display-message -p -F '#{session_id}')
	new_session_id=$(tmux new-session -d -P -F "#{session_id}")
	echo "a: $current_session_id  b: $new_session_id" >> $LOG
	first_window_id=$(tmux list-windows -t $new_session_id -F '#{window_id}' | head -n 1)
	tmux move-window -s $current_window_id -t $new_session_id >> $LOG
	tmux kill-window -t $first_window_id
	tmux switch-client -t $new_session_id >> $LOG
	exit
else
	echo standard-new-session >> $LOG
fi


target_window_id_raw=$(echo $1 | awk '{print $1}')
target_window_id="@$target_window_id_raw"

target_session_name=$(tmux display-message -p -t "$target_window_id" '#{session_name}')


src_window_id_raw="${current_window_id:1}"

target_index=$(tmux display-message -p -t "$target_window_id" -F '#{window_index}')

$CURRENT_DIR/window-move.sh $src_window_id_raw $target_index $target_session_name >> $LOG

tmux select-window -t "$current_window_id"
tmux switch-client -t "$target_session_name"

