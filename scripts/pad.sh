#!/usr/bin/env bash

# whitespace pad to $1 length
awk -v width=$1 '{ visible_line = $0; gsub(/\033\[[0-9;]*m/, "", visible_line); padding_length = width - length(visible_line); if (padding_length > 0) { padding = sprintf("%*s", padding_length, ""); gsub(/ /, " ", padding); print $0 padding } else { print substr(visible_line, 1, width) } }'
