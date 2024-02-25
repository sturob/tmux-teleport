#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# this is all a workaround split-window not having a -Z in old versions
# pane_id=$(tmux split-window -P -F "#{pane_id}" -f -c "~")

pane_sizes=$(tmux list-panes -F "#{pane_id} #{pane_width} #{pane_height}")

restore_pane_sizes() {
    echo "$pane_sizes" | while IFS= read -r line; do
        pane_id=$(echo $line | cut -d ' ' -f 1)
        pane_width=$(echo $line | cut -d ' ' -f 2)
        pane_height=$(echo $line | cut -d ' ' -f 3)
        tmux resize-pane -t $pane_id -x $pane_width -y $pane_height
    done
}

tmux resize-pane -Z
$CURRENT_DIR/tmux-teleport.sh

# tmux break-pane

# restore_pane_sizes
