#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

text="press ? for help"

# Get the length of the text and the width and height of the terminal
text_length=${#text}
terminal_width=$(tput cols)
terminal_height=$(tput lines)

# Calculate the horizontal and vertical padding
padding_horizontal=$(( (terminal_width - text_length) / 2 ))
padding_vertical=$(( (terminal_height - 1) / 2 ))

# Print the vertical padding
# for ((i=1; i<=padding_vertical; i++)); do
#     echo
# done

$CURRENT_DIR/gather-tasks.sh

# Print the horizontal padding and the text
printf "%${padding_horizontal}s" ' '
echo "$text"

dir="/tmp/tmux-back"
tty=$(tmux display-message -p -F "#{client_tty}" | tr '/' '_')
file="$dir/$tty-state.log"

tail -n 35 "$file" | sed '$d' | tac | /home/stu/.tmux/plugins/tmux-backspin/scripts/format-history.sh
