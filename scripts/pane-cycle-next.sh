#!/bin/bash

if [[ $1 =~ .*new$ || $1 == '' ]]; then
	exit
fi

window_id=$(echo $1 | awk '{print $1}')
window_name=$(echo $1 | awk '{print $4}')

lines=$(tmux list-panes -t "@$window_id" -F "#{pane_id} #{pane_active}")
echo $lines
mapfile -t lines <<< "$lines"


# Get the number of lines in the file
num_lines=${#lines[@]}

# Iterate over the lines
for ((i=0; i<$num_lines; i++)); do
    # Split the line into id and is_active
    IFS=' ' read -ra parts <<< "${lines[$i]}"

    # Check if is_active is 1
    if [[ "${parts[1]}" == "1" ]]; then
        # Get the id of the next line, wrapping around to the first line if necessary
        next_line=$(( (i+1) % $num_lines ))
        IFS=' ' read -ra next_parts <<< "${lines[$next_line]}"
		tmux select-pane -t "${next_parts[0]}"
        exit 0
    fi
done

# If we get here, no line with is_active == 1 was found
exit 1
