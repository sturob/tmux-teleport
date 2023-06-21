#!/usr/bin/env bash

# Check if script arguments are provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 target"
    exit 1
fi

target=$1
last_number=$target

# Read numbers line by line
while IFS= read -r number; do
    if (( number <= target )); then
        continue
    fi

    if (( number > last_number + 1 )); then
        echo $((last_number + 1))
        exit 0
    fi

    last_number=$number
done

# If no gap is found, return last_number + 1
echo $((last_number + 1))

