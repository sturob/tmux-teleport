#!/usr/bin/env bash

LOG="/tmp/tmux-teleport.log"
CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

src_window_id_raw=$(echo $1 | awk '{print $1}')
target_session_name=$(tmux display-message -p '#{session_name}')
current_window_id=$(tmux display-message -p '#{window_id}')
target_index=$(tmux display-message -p -t "$current_window_id" -F '#{window_index}')

$CURRENT_DIR/window-move.sh $src_window_id_raw $target_index $target_session_name >> $LOG

