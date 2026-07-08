#### --- Status Bar Styling --- ####
# set -g status-position bottom
set -g status-position top
set -g status-interval 5
set -g status-justify left
set -g status-left-length 100
set -g status-right-length 100
set -g status on

# Gruvbox dark background (blends with terminal theme)
set -g status-bg '#1e282d'

# Status left: empty
set -g status-left ''

# Status right: session name (green)
set -g status-right '#[fg=#636B2F,bold] #S#[nobold]  '

# Window status format
set -g window-status-separator '  '

# Inactive windows (just colored text, no box)
set -g window-status-format '#[fg=#666666]#I #W'

# Active window (gold accent, bold, no box)
set -g window-status-current-format '#[fg=#EFBF04,bold]#I #[fg=#EFBF04,bold]#W'

# Pane borders
set -g pane-border-style 'fg=#504945'
set -g pane-active-border-style 'fg=#636B2F'

# Message styling
set -g message-style 'fg=#dce3e8,bg=#504945'
set -g message-command-style 'fg=#dce3e8,bg=#504945'
