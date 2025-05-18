#### --- TPM Plugins --- ####
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'
set -g @plugin 'catppuccin/tmux'
set -g @plugin 'christoomey/vim-tmux-navigator'



# List of plugins
set -g @plugin 'tmux-plugins/tpm'
# set -g @plugin 'catppuccin/tmux'
# set -g @plugin 'christoomey/vim-tmux-navigator'


# # Configure the catppuccin plugin
# set -g @catppuccin_flavor "macchiato"
# set -g @catppuccin_window_status_style "rounded"
# # leave this unset to let applications set the window title
# set -g @catppuccin_window_default_text " #W"
# set -g @catppuccin_window_current_text " #W"
# set -g @catppuccin_window_status "icon"
# set -g @catppuccin_window_current_background "#{@thm_mauve}"

# Load catppuccin
# run ~/.config/tmux/plugins/catppuccin/tmux/catppuccin.tmux
# For TPM, instead use `run ~/.config/tmux/plugins/tmux/catppuccin.tmux`

# Make the status line pretty and add some modules
# set -g status-left ""
# set -g status-right "#{E:@catppuccin_status_user}"
# set -ag status-right "#{E:@catppuccin_status_directory}"
# set -g @catppuccin_status_connect_separator "no"

# set -g @catppuccin_directory_text "#{pane_current_path}"
