#!/bin/bash 

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
LOG="/tmp/tmux-teleport.log"

target_id_raw=$(echo $1 | awk '{print $1}')
target_id="@$target_id_raw"

src_id_raw=$(tmux show-environment -g cut_window_id | awk -F "=" '{print $2}')
src_id="@$src_id_raw"

target_index=$(tmux display-message -p -t "$target_id" -F '#{window_index}')
target_session=$(tmux display-message -p -t "$target_id" -F '#{session_name}')

current_id=$(tmux display-message -p -F '#{window_id}')
this_session=$(tmux display-message -p '#{session_name}')

$CURRENT_DIR/window-move.sh $src_id_raw $target_index $target_session

if [[ "$src_id" == "$current_id" && "$this_session" != "$target_session" ]]; then # we're moving current cross-session
	tmux select-window -t "$current_id"
	tmux switch-client -t "$target_session"
fi
