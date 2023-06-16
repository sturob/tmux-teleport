#!/bin/bash

LOG="/tmp/tmux-teleport.log"
CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

target_window_id_raw=$(echo $1 | awk '{print $1}')
target_window_id="@$target_window_id_raw"

target_session_name=$(tmux display-message -p -t "$target_window_id" '#{session_name}')

current_window_id=$(tmux display-message -p -F '#{window_id}')

src_window_id_raw="${current_window_id:1}"

target_index=$(tmux display-message -p -t "$target_window_id" -F '#{window_index}')

$CURRENT_DIR/window-move.sh $src_window_id_raw $target_index $target_session_name >> $LOG

tmux select-window -t "$current_window_id"
tmux switch-client -t "$target_session_name"
