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

# Status right: battery + time (green)
set -g status-right '#[fg=#06B6D4]#{battery_icon} #{battery_percentage} | %H:%M '

# Custom status format: tabs on the left, session name centered, status-right on the right
set -g status-format[0] '#[list=on align=#{status-justify}]#[list=left-marker]<#[list=right-marker]>#[list=on]#{W:#[range=window|#{window_index} #{E:window-status-style}#{?#{&&:#{window_last_flag},#{!=:#{E:window-status-last-style},default}}, #{E:window-status-last-style},}#{?#{&&:#{window_bell_flag},#{!=:#{E:window-status-bell-style},default}}, #{E:window-status-bell-style},#{?#{&&:#{||:#{window_activity_flag},#{window_silence_flag}},#{!=:#{E:window-status-activity-style},default}}, #{E:window-status-activity-style},}}]#[push-default]#{T:window-status-format}#[pop-default]#[norange default]#{?window_end_flag,,#{window-status-separator}},#[range=window|#{window_index} list=focus #{?#{!=:#{E:window-status-current-style},default},#{E:window-status-current-style},#{E:window-status-style}}#{?#{&&:#{window_last_flag},#{!=:#{E:window-status-last-style},default}}, #{E:window-status-last-style},}#{?#{&&:#{window_bell_flag},#{!=:#{E:window-status-bell-style},default}}, #{E:window-status-bell-style},#{?#{&&:#{||:#{window_activity_flag},#{window_silence_flag}},#{!=:#{E:window-status-activity-style},default}}, #{E:window-status-activity-style},}}]#[push-default]#{T:window-status-current-format}#[pop-default]#[norange list=on default]#{?window_end_flag,,#{window-status-separator}}}#[nolist]#[align=centre]#[push-default]#[fg=#06B6D4,bold] #S #[nobold]#[pop-default]#[norange default]#[nolist align=right range=right #{E:status-right-style}]#[push-default]#{T;=/#{status-right-length}:status-right}#[pop-default]#[norange default]'
