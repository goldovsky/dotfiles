#### --- Status Bar Styling --- ####

# Load colors from shared theme
source ~/git/dotfiles/shell/common/themes/outputs/tmux-colors.tmux

set -g status-position top
set -g status-interval 5
set -g status-justify left
set -g status-left-length 100
set -g status-right-length 100
set -g status on

# Status left: empty (tabs start at the left edge)
set -g status-left ''

# Window status format
set -g window-status-separator '  '

# Status right: battery + time (grey)
set -g status-right '#[fg=#94A3B8] %H:%M  #{battery_icon} #{battery_percentage} '

# Custom status format (3 columns): tabs left, session name centered, status-right right
# Built from small @sf_* parts so each line stays readable.
# Tabs / window list (left)
set -g @sf_tabs '#[list=on align=#{status-justify}]#[list=left-marker]<#[list=right-marker]>#[list=on]#{W:#[range=window|#{window_index} #{E:window-status-style}]#[push-default]#{T:window-status-format}#[pop-default]#[norange default]#{?window_end_flag,,#{window-status-separator}},#[range=window|#{window_index} list=focus #{E:window-status-current-style}]#[push-default]#{T:window-status-current-format}#[pop-default]#[norange list=on default]#{?window_end_flag,,#{window-status-separator}}}'
# Session name (center)
set -g @sf_center '#[nolist]#[align=centre]#[push-default]#[fg=#06B6D4,bold] #S #[nobold]#[pop-default]#[norange default]'
# Status right (battery + time)
set -g @sf_right '#[nolist align=right range=right #{E:status-right-style}]#[push-default]#{T;=/#{status-right-length}:status-right}#[pop-default]#[norange default]'
# Assemble them into the status line
set -g status-format[0] '#{E:@sf_tabs}#{E:@sf_center}#{E:@sf_right}'
