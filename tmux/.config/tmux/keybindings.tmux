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
