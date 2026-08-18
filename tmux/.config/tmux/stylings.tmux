# Icons
## stow the icon file to source it from it
ic_s="󱑼"
ic_b="󱐋"
ic_ll=""
ic_lr=""
ic_rl=""
ic_rr=""

#### --- General Settings --- ####
set -g status-position top
set -g status-left-length 100
set -g window-status-separator ""
set -g status-style "fg=${cl_bright_white},bg=${cl_default}"

# Pane borders
set -g pane-border-style "fg=${cl_border}"
set -g pane-active-border-style "fg=${cl_accent}"

# Message styling
set -g message-style "fg=${cl_bright_white},bg=${cl_border}"
set -g message-command-style "fg=${cl_bright_white},bg=${cl_border}"

#### --- Variables For Status Bar --- ####
set -g @sf_sessioniconleft "#[fg=${cl_bright_white},bg=${cl_accent}] ${ic_s} #[bg=${cl_default},fg=${cl_accent}]${ic_lr}"
set -g @sf_sessionname "#[bg=${cl_default},fg=${cl_border}]${ic_ll}#[fg=${cl_accent},bold,bg=${cl_border}] #S #[bg=${cl_default},fg=${cl_border}]${ic_lr}"

set -g @sf_time "#[bg=${cl_default},fg=${cl_border}]${ic_rl}#[fg=${cl_bright_white},bg=${cl_border}] %H:%M #[fg=${cl_border},bg=${cl_default}]${ic_rr}"
set -g @sf_batteryicon "#[fg=${cl_accent},bg=${cl_border}]${ic_b} "

#### --- Status Bar Styling --- ####
set -g status-left "#{E:@sf_sessioniconleft}#{E:@sf_sessionname}"

set -g window-status-format "#[bg=${cl_default},fg=${cl_border}]${ic_ll}#[fg=${cl_inactive},bg=${cl_border}] #W #[bg=${cl_default},fg=${cl_border}]${ic_lr}"
set -g window-status-current-format "#[bg=${cl_default},fg=${cl_border}]${ic_ll}#[fg=${cl_active},bold,bg=${cl_border}] #W #[bg=${cl_default},fg=${cl_border}]${ic_lr}"

set -g status-right "#[bg=${cl_default},fg=${cl_border}]${ic_rl}#[fg=${cl_inactive},bg=${cl_border}]#{weather} #[fg=${cl_border},bg=${cl_default}]${ic_rr}#{E:@sf_time}#[fg=${cl_border},bg=${cl_default}]${ic_rl}#[fg=${cl_bright_white},bg=${cl_border}] #{battery_percentage} #{E:@sf_batteryicon}"
