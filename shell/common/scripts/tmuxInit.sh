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

  # Idempotent: without this, re-running tmx errors out on new-session and then
  # attaches anyway, re-creating the default windows in the process.
  # tmx bootstraps the "home" session; per-project sessions come from
  # prefix + f (tmux/.config/tmux/scripts/sessionizer.sh).
  if tmux has-session -t="$session_name" 2>/dev/null; then
    if [ -n "${TMUX:-}" ]; then
      tmux switch-client -t "$session_name"
    else
      tmux attach-session -t "$session_name"
    fi
    return
  fi

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
