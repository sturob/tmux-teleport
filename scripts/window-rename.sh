#!/bin/bash

window_id=$(echo $1 | awk '{print $1}')
window_name=$(tmux display-message -p -t "@$window_id" '#{window_name}')

tmux command-prompt -I"$window_name" "rename-window -t \"@$window_id\" -- '%%'"

