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
# Two variants, selected by @docker_mode. They are kept in separate options on
# purpose: #{?cond,a,b} splits on commas, and "#[fg=...,bg=...]" contains some,
# which would break the conditional if inlined.
set -g @sf_left_normal "#[fg=${cl_bright_white},bg=${cl_accent}] ${ic_s} #[bg=${cl_default},fg=${cl_accent}]${ic_lr}"
set -g @sf_left_docker "#[fg=${cl_default},bg=${cl_active},bold] ${ic_d} #[bg=${cl_default},fg=${cl_active},nobold]${ic_lr}"
set -g @sf_sessioniconleft "#{?#{==:#{@docker_mode},1},#{E:@sf_left_docker},#{E:@sf_left_normal}}"

# The dot after #S is the dev container health: green when it runs, nothing at
# all otherwise. The nested #{@dev_container} is expanded by tmux before the
# script runs; it comes from ~/.config/tmux/local.tmux (not versioned). The
# script only emits "#[fg=...]", so bg=${cl_border} carries over to the space
# that follows, which is kept unconditionally to keep the badge width stable.
set -g @sf_sessionname "#[bg=${cl_default},fg=${cl_border}]${ic_ll}#[fg=${cl_accent},bold,bg=${cl_border}] #S #(~/.config/tmux/scripts/docker-status.sh #{@dev_container} ${cl_accent}) #[bg=${cl_default},fg=${cl_border}]${ic_lr}"

# Only rendered while synchronize-panes is on (prefix + S).
set -g @sf_sync_on "#[bg=${cl_default},fg=${cl_active}]${ic_ll}#[fg=${cl_default},bg=${cl_active},bold] ${ic_sync} SYNC #[bg=${cl_default},fg=${cl_active},nobold]${ic_lr}"
set -g @sf_sync "#{?pane_synchronized,#{E:@sf_sync_on},}"

set -g @sf_time "#[bg=${cl_default},fg=${cl_border}]${ic_rl}#[fg=${cl_bright_white},bg=${cl_border}] %H:%M #[fg=${cl_border},bg=${cl_default}]${ic_rr}"
set -g @sf_batteryicon "#[fg=${cl_accent},bg=${cl_border}]${ic_b} "

#### --- Status Bar Styling --- ####
set -g status-left "#{E:@sf_sessioniconleft}#{E:@sf_sessionname}#{E:@sf_sync}"

set -g window-status-format "#[bg=${cl_default},fg=${cl_border}]${ic_ll}#[fg=${cl_inactive},bg=${cl_border}] #W #[bg=${cl_default},fg=${cl_border}]${ic_lr}"
set -g window-status-current-format "#[bg=${cl_default},fg=${cl_border}]${ic_ll}#[fg=${cl_active},bold,bg=${cl_border}] #W #[bg=${cl_default},fg=${cl_border}]${ic_lr}"

set -g status-right "#[bg=${cl_default},fg=${cl_border}]${ic_rl}#[fg=${cl_inactive},bg=${cl_border}] #{weather} #[fg=${cl_border},bg=${cl_default}]${ic_rr}#{E:@sf_time}#[fg=${cl_border},bg=${cl_default}]${ic_rl}#[fg=${cl_bright_white},bg=${cl_border}] #{battery_percentage} #{E:@sf_batteryicon}"
