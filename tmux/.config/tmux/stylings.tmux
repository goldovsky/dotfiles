# Load colors from shared theme
## TODO change the script to generate those colors
# source ~/git/dotfiles/shell/common/themes/outputs/tmux-colors.tmux

# Colors declaration
cl_default="default"
cl_background="#1E3A5F"
cl_inactive="#94A3B8"
cl_active="#FFC600"
cl_accent="#00C16A"
cl_white="#FFFFFF"

ic_s="󱑼"
ic_b="󱐋"
ic_ll=""
ic_lr=""
ic_rl=""
ic_rr=""


#### --- General Settings --- ####
set -g status-position top
set -g status-left-length 100
# set -g window-status-separator ""
# set -g status-style "fg=${cl_white},bg=${cl_default}"

# Pane borders
# set -g pane-border-style "fg=${cl_background}"
# set -g pane-active-border-style "fg=#00DC82"

# Message styling
set -g message-style "fg=${cl_white},bg=${cl_background}"
set -g message-command-style "fg=${cl_white},bg=${cl_background}"


#### --- Variables For Status Bar --- ####

set -g @sf_sessioniconleft "#[fg=${cl_white},bg=${cl_accent}] 󱑼 #[bg=${cl_default},fg=${cl_accent}]"
set -g @sf_sessionname "#[bg=${cl_default},fg=${cl_background}]#[fg=${cl_accent},bold,bg=${cl_background}] #S #[bg=${cl_default},fg=${cl_background}]"

set -g @sf_time "#[bg=${cl_default},fg=${cl_background}]#[fg=${cl_white},bg=${cl_background}] %H:%M #[fg=${cl_background},bg=${cl_default}]"
set -g @sf_batteryicon "#[fg=${cl_accent},bg=${cl_background}]󱐋 "

#### --- Status Bar Styling --- ####

set -g status-left "#{E:@sf_sessioniconleft}#{E:@sf_sessionname}"

set -g window-status-format "#[bg=${cl_default},fg=${cl_background}]#[fg=${cl_inactive},bg=${cl_background}] #W #[bg=${cl_default},fg=${cl_background}]"
set -g window-status-current-format "#[bg=${cl_default},fg=${cl_background}]#[fg=${cl_active},bold,bg=${cl_background}] #W #[bg=${cl_default},fg=${cl_background}]"

set -g status-right "#[bg=${cl_default},fg=${cl_background}]#[fg=${cl_inactive},bg=${cl_background}]#{weather} #[fg=${cl_background},bg=${cl_default}]#{E:@sf_time}#[fg=${cl_background},bg=${cl_default}]#[fg=${cl_white},bg=${cl_background}] #{battery_percentage} #{E:@sf_batteryicon}"
