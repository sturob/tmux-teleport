#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

tmux bind      'g'   "split-window -v -f '$CURRENT_DIR/scripts/run.sh'"
tmux bind -n   M-/   "split-window -v -f '$CURRENT_DIR/scripts/run.sh'"
