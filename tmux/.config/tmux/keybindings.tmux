# Change prefix from 'Ctrl+B' to 'Ctrl+space'
set -g prefix C-Space
unbind C-b
bind C-Space send-prefix

# Reload tmux config
unbind r
bind r source-file ~/.tmux.conf \; display-message "Tmux config reloaded!"

# VIM Navigation
bind-key h select-pane -L
bind-key j select-pane -D
bind-key k select-pane -U
bind-key l select-pane -R

# # Use xclip to copy and paste with the system clipboard
bind C-c run "tmux save-buffer - | xclip -i -sel clip"
bind C-v run "tmux set-buffer $(xclip -o -sel clip); tmux paste-buffer"
