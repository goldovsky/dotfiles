#!/bin/bash

tmx() {
  local session_name="󰬁󰫺󰬂󰬅"

  local OPTIND
  while getopts "s:" opt; do
    case $opt in
      s) session_name="$OPTARG" ;;
    esac
  done
  shift $((OPTIND - 1))

  tmux new-session -d -s "$session_name" -n "󰈸 "

  local default_windows=("󰒲 " "󰚩 ")
  for win in "${default_windows[@]}"; do
    tmux new-window -t "$session_name" -n "$win"
  done

  for arg in "$@"; do
    tmux new-window -t "$session_name" -n "$arg"
  done

  tmux set-option -g allow-rename off
  tmux select-window -t "$session_name:󰈸 "
  tmux attach-session -t "$session_name"
}
