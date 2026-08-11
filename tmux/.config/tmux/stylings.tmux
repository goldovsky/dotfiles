#### --- Status Bar Styling --- ####

# Load colors from shared theme
source ~/git/dotfiles/shell/common/themes/outputs/tmux-colors.tmux

# Lighter segments for the outer status parts (windows / time+battery)
set -g window-status-style 'bg=#1E3A5F'
set -g window-status-current-style 'bg=#1E3A5F'

set -g status-position top
set -g status-interval 5
set -g status-justify left
set -g status-left-length 100
set -g status-right-length 100
set -g status on

# Status left: empty (tabs start at the left edge)
set -g status-left ''

# Window status format: slanted buttons (title only), overrides generated theme formats
set -g window-status-separator ' '
set -g window-status-format '#[bg=#0E1D31,fg=#1E3A5F]#[fg=#94A3B8,bg=#1E3A5F] #W #[bg=#0E1D31,fg=#1E3A5F]'
set -g window-status-current-format '#[bg=#0E1D31,fg=#1E3A5F]#[fg=#FFC600,bold,bg=#1E3A5F] #W #[bg=#0E1D31,fg=#1E3A5F]'

# Status right: battery + time (white)
set -g status-right '#[fg=#FFFFFF,bg=#1E3A5F]%H:%M  󰁹 #{battery_percentage} '

# Custom status format: session block + window buttons (left), status-right right
# Built from small @sf_* parts so each line stays readable.
# Session block + window buttons (left)
set -g @sf_tabs '#[fg=#FFFFFF,bg=#1E3A5F] 󱑼  #[fg=#06B6D4,bold,bg=#1E3A5F]#S #[bg=#0E1D31,fg=#1E3A5F] #[list=on align=#{status-justify}]#[list=left-marker]<#[list=right-marker]>#[list=on]#{W:#[range=window|#{window_index} #{E:window-status-style}]#[push-default]#{T:window-status-format}#[pop-default]#[norange]#{?window_end_flag,,#{window-status-separator}},#[range=window|#{window_index} list=focus #{E:window-status-current-style}]#[push-default]#{T:window-status-current-format}#[pop-default]#[norange list=on]#{?window_end_flag,,#{window-status-separator}}}'
# Status right (battery + time)
set -g @sf_right '#[nolist align=right range=right #{E:status-right-style}]#[bg=#0E1D31,fg=#1E3A5F]#[bg=#1E3A5F] #[fg=#FFFFFF,bg=#1E3A5F]#[push-default]#{T;=/#{status-right-length}:status-right}#[pop-default]#[norange default]'
# Assemble them into the status line
set -g status-format[0] '#{E:@sf_tabs}#{E:@sf_right}'
