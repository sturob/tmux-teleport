#!/usr/bin/env bash

selected_window_id_raw=$(echo $1 | awk '{print $1}')

window_name=$(tmux display-message -p -t "@$selected_window_id_raw" '#{window_name}')

# unlink or delete if last link
tmux confirm-before -p "Delete $window_name ? (y/n)" "unlink-window -k -t @$selected_window_id_raw"
