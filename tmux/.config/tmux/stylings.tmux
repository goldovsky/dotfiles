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
set -g status-bg '#1f2430'

# Unicode segments
set -g status-left '#[fg=#fe8019,bg=#1f2430]#[fg=#dce3e8,bg=#fe8019,bold] #S#[fg=#fe8019,bg=#003b46,nobold]'
set -g status-right ''

# Active window style
set -g @catppuccin_window_current_text " #W"
set -g @catppuccin_window_current_fill "all"
set -g @catppuccin_window_current_background "#b8bb26"
# Inactive window style
set -g @catppuccin_window_default_text " #W"
