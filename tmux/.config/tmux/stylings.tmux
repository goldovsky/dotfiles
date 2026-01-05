#### --- Status Bar Styling --- ####
set -g status-position bottom
# set -g status-position top
set -g status-interval 5
set -g status-justify right
set -g status-left-length 100
set -g status-right-length 100
set -g status on

# Gruvbox dark background (blends with terminal theme)
set -g status-bg '#282828'

# Status left: arrow-shaped badge (green, matching active window)
set -g status-left '#[fg=#b8bb26,bold] #S#[nobold]  '

# Status right: empty
set -g status-right ''

# Window status format
set -g window-status-separator '  '

# Inactive windows (just colored text, no box)
set -g window-status-format '#[fg=#7c6f64]#I #W'

# Active window (green accent, bold, no box)
set -g window-status-current-format '#[fg=#b8bb26,bold]#I #W'

# Pane borders
set -g pane-border-style 'fg=#504945'
set -g pane-active-border-style 'fg=#b8bb26'

# Message styling
set -g message-style 'fg=#dce3e8,bg=#504945'
set -g message-command-style 'fg=#dce3e8,bg=#504945'
