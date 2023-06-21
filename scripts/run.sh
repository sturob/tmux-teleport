#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# this is all a workaround split-window not having a -Z in old versions
# pane_id=$(tmux split-window -P -F "#{pane_id}" -f -c "~")

tmux resize-pane -Z
$CURRENT_DIR/tmux-teleport.sh
