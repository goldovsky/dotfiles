#### --- TPM Plugins --- ####
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'
set -g @plugin 'christoomey/vim-tmux-navigator'
set -g @plugin 'tmux-plugins/tmux-battery'
set -g @plugin 'xamut/tmux-weather'
set -g @plugin 'tmux-plugins/tmux-resurrect'
set -g @plugin 'tmux-plugins/tmux-continuum'

#### --- Session persistence --- ####
# resurrect saves sessions/windows/panes/layouts; continuum calls it on a timer
# and restores once when the server starts.
set -g @resurrect-capture-pane-contents 'on'
set -g @resurrect-strategy-nvim 'session'
set -g @continuum-restore 'on'
set -g @continuum-save-interval '15'

# NOTE: resurrect does not save custom window options, so @docker_mode does not
# survive a restore — restored windows come back as plain host shells. This is
# deliberate: the container is usually down right after a reboot, so restoring
# the flag would show the docker badge on panes that are not in the container.
# Use prefix + C-d to re-enter docker-mode where you want it.


# Avoid emoji-width alignment glitches in tmux status-right.
set -g @tmux-weather-format '%t'

# Battery icons (Nerd Font) - the default emoji don't render in all fonts
set -g @batt_icon_status_charged '󱟢'
set -g @batt_icon_status_charging '󰂄'
set -g @batt_icon_status_discharging '󰁾'
set -g @batt_icon_status_attached '󱊣'
set -g @batt_icon_status_unknown '?'
