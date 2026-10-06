# Change prefix from 'Ctrl+B' to 'Ctrl+space'
set -g prefix C-Space
unbind C-b
bind C-Space send-prefix

# Add backtick as secondary prefix (QWERTY - key next to 1)
set -g prefix2 `
bind ` send-keys `

# Add œ as prefix trigger (AZERTY - key next to 1)
bind -n œ switch-client -T prefix
bind œ send-keys œ

# Reload tmux config
unbind r
bind r source-file ~/.tmux.conf \; display-message "Tmux config reloaded!"

#### --- Sessions --- ####

# fzf project picker: one git repo -> one session, never a duplicate.
# Runs in a popup so it overlays the current session instead of hijacking a pane.
bind f display-popup -w 70% -h 60% -E "~/.config/tmux/scripts/sessionizer.sh"

# Jump between existing sessions: tmux already binds prefix + s to
# `choose-tree -Zs`, so there is nothing to add here.

# New window in the CURRENT directory. Without -c, tmux uses the directory the
# session was created in, which after a sessionizer jump is rarely where you are.
bind c new-window -c "#{pane_current_path}"

# # Use xclip to copy and paste with the system clipboard
bind C-c run "tmux save-buffer - | xclip -i -sel clip"
bind C-v run "tmux set-buffer $(xclip -o -sel clip); tmux paste-buffer"

# split window
# In docker-mode the new pane opens straight inside the dev container.
# The decision is made here rather than through `default-command` because that
# option only exists at SESSION level: it would also apply to brand new windows,
# so opening a window for a quick host shell would land in the container.
bind - if -F '#{==:#{@docker_mode},1}' \
    'split-window -v -c "#{pane_current_path}" "~/.config/tmux/scripts/dev-shell.sh"' \
    'split-window -v -c "#{pane_current_path}"'
bind | if -F '#{==:#{@docker_mode},1}' \
    'split-window -h -c "#{pane_current_path}" "~/.config/tmux/scripts/dev-shell.sh"' \
    'split-window -h -c "#{pane_current_path}"'

# Resize panes. -r makes them repeatable within repeat-time (settings.tmux),
# so the prefix is pressed once and H/J/K/L can then be held.
# Uppercase on purpose: lowercase h/j/k/l belong to vim-tmux-navigator.
bind -r H resize-pane -L 5
bind -r J resize-pane -D 5
bind -r K resize-pane -U 5
bind -r L resize-pane -R 5

# Copy mode, vi style. `mode-keys vi` (settings.tmux) only gives vi MOTIONS;
# the selection keys still have to be bound explicitly.
bind -T copy-mode-vi v send-keys -X begin-selection
bind -T copy-mode-vi C-v send-keys -X rectangle-toggle
bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel 'xsel -i -b'
bind -T copy-mode-vi Escape send-keys -X cancel

# Synchronize panes: type once, send to every pane of the window
bind S setw synchronize-panes \; display-message "sync-panes #{?pane_synchronized,ON,OFF}"

#### --- Docker dev container --- ####

# Start the dev stack without attaching a shell.
# Runs in a popup so image pulls/builds stay visible. -EE closes the popup only
# on success: if the stack fails to start, it stays open so the error is readable.
# The command itself lives in dev-up.sh because display-popup does NOT expand
# #{...} formats in its shell-command argument.
bind C-u display-popup -w 80% -h 80% -EE "~/.config/tmux/scripts/dev-up.sh"

# Toggle docker-mode for the CURRENT WINDOW (note the `setw`, not `set`).
# Window scope on purpose: a new window then still gives a plain host shell,
# which is the usual "I just need a quick shell" case.
# dev-mode-apply.sh converts the panes that already exist, but only those
# sitting idle at a shell prompt: switching a live pane means respawning it,
# which would kill whatever runs inside and leave it orphaned in the container.
# Prefixing each typed command was deliberately avoided: every `docker exec` is a
# fresh process, so `cd`, env vars and shell state would not persist.
bind C-d if -F '#{==:#{@docker_mode},1}' \
    'setw -u @docker_mode ; run-shell "~/.config/tmux/scripts/dev-mode-apply.sh off #{pane_id}"' \
    'setw @docker_mode 1 ; run-shell "~/.config/tmux/scripts/dev-mode-apply.sh on #{pane_id}"'
