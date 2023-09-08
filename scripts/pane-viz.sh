#!/usr/bin/env bash

LOG="/tmp/tmux-teleport.log"
CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# ANSI color codes
BLUE="\033[0;34m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
WHITE="\033[0;37m"
RESET="\033[0m"

# Get list of windows
windows=$(tmux list-windows -F "#{window_id}")

# For each window
for window in $windows; do
    # Fetch the root directory for the window and print it in blue
    root_dir=$(tmux display-message -p -F "#{pane_current_path}" -t "${window}.0")
    echo -ne "${BLUE}[${root_dir}]${RESET}"

    # Get list of panes in this window
    panes=$(tmux list-panes -t $window -F "#{pane_id}")

    # For each pane in the window
    for pane in $panes; do
        # Fetch the current process for the pane
        process=$(tmux display-message -p -F "#{pane_current_command}" -t $pane)

        # Determine the color based on the type of process
        if [[ $process == "vim" || $process == "nano" ]]; then
            color=$GREEN
        elif [[ $process == "top" || $process == "htop" || $process == "tail" ]]; then
            color=$YELLOW
        else
            color=$WHITE
        fi

        # Print the pane info (pane ID and process) in the appropriate color
        echo -ne "${color}<Pane ${pane} - ${process}>${RESET}"
    done
	echo
done

