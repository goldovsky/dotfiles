# Change prefix from 'Ctrl+B' to 'Ctrl+space'
set -g prefix C-Space
unbind C-b
bind C-Space send-prefix

# Reload tmux config
unbind r
bind r source-file ~/.tmux.conf \; display-message "Tmux config reloaded!"

# # Use xclip to copy and paste with the system clipboard
bind C-c run "tmux save-buffer - | xclip -i -sel clip"
bind C-v run "tmux set-buffer $(xclip -o -sel clip); tmux paste-buffer"

# split window
bind - split-window -v -c "#{pane_current_path}" # horizontal split (pane below)
bind | split-window -h -c "#{pane_current_path}" # vertical split (pane to the right)
