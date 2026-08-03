#### --- Status Bar Styling --- ####
set -g status-position top
set -g status-interval 5
set -g status-justify left
set -g status-left-length 100
set -g status-right-length 100
set -g status on

# Status left: empty
set -g status-left ''

# Window status format
set -g window-status-separator '  '

# SHow battery life
set -g status-right '#{battery_icon} #{battery_percentage} | %H:%M '

# Load colors from shared theme
source ~/git/dotfiles/shell/common/themes/outputs/tmux-colors.tmux
