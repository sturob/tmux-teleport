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
# last_window_id=$(tmux list-windows -F "#{window_id} #{window_last_flag}" | grep '1$' | cut -d' ' -f1)
this_session=$(tmux display-message -p '#{session_name}')

$CURRENT_DIR/window-move.sh $src_id_raw $target_index $target_session
