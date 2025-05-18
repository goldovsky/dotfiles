#### --- Status Bar Styling --- ####
set -g status-position bottom
set -g status-interval 5
set -g status-justify centre
set -g status-left-length 100
set -g status-right-length 100
set -g status on

# Gruvbox colors (use same palette as Starship)
set -g status-bg '#003b46'
set -g status-fg '#dce3e8'

# Unicode segments
set -g status-left '#[fg=#b8bb26,bg=#1f2430]#[fg=#181926,bg=#b8bb26,bold] #S #[fg=#b8bb26,bg=#003b46,nobold]'
set -g status-right '#[fg=#006374,bg=#003b46]#[fg=#dce3e8,bg=#006374] %Y-%m-%d #[fg=#006374,bg=#0093a3]#[fg=#dce3e8,bg=#0093a3] %R #[fg=#0093a3,bg=#1f2430] '

# Active window style
setw -g window-status-current-format '#[fg=#fe8019,bold] #I:#W '
setw -g window-status-format '#[fg=#dce3e8] #I:#W '

# Catppuccin Theme
set -g @catppuccin_flavor 'macchiato'
set -g @catppuccin_window_status_style 'rounded'
set -g @catppuccin_status_connect_separator "no"
set -g @catppuccin_directory_text "#{pane_current_path}"
