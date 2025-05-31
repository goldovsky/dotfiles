# Catppuccin Theme
set -g @catppuccin_flavor 'macchiato'
set -g @catppuccin_window_status_style 'rounded'

#### --- Status Bar Styling --- ####
set -g status-position top # set-option -g status-position top
set -g status-interval 5
set -g status-justify right
set -g status-left-length 100
set -g status-right-length 100
set -g status on

# Gruvbox colors (use same palette as Starship)
# set -g status-bg '#003b46'
# set -g status-fg '#dce3e8'

# Unicode segments
set -g status-left '#[fg=#b8bb26,bg=#1f2430]#[fg=#181926,bg=#b8bb26,bold] #S #[fg=#b8bb26,bg=#003b46,nobold]'
set -g status-right '#[fg=#fe8019,bg=default]#[fg=#dce3e8,bg=#fe8019]󰚩 #[fg=#fe8019,bg=#1f2430]'

# Active window style
set -g @catppuccin_window_current_text " #W"
set -g @catppuccin_window_current_fill "all"
# set -g @catppuccin_window_current_background "#{@thm_mauve}"
# Inactive window style
set -g @catppuccin_window_default_text " #W"
