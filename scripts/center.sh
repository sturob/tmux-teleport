#!/usr/bin/env bash

text="press ? for help"

# Get the length of the text and the width and height of the terminal
text_length=${#text}
terminal_width=$(tput cols)
terminal_height=$(tput lines)

# Calculate the horizontal and vertical padding
padding_horizontal=$(( (terminal_width - text_length) / 2 ))
padding_vertical=$(( (terminal_height - 1) / 2 ))

# Print the vertical padding
for ((i=1; i<=padding_vertical; i++)); do
    echo
done

# Print the horizontal padding and the text
printf "%${padding_horizontal}s" ' '
echo "$text"

