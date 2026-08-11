# Load colors from shared theme
source ~/git/dotfiles/shell/common/themes/outputs/tmux-colors.tmux

#### --- Variables --- ####

set -g @sf_sessioniconleft '#[fg=#FFFFFF,bg=#00C16A] 󱑼 #[bg=#0E1C30,fg=#00C16A]'
set -g @sf_sessionname '#[bg=#0E1C30,fg=#1E3A5F]#[fg=#00C16A,bold,bg=#1E3A5F] #S #[bg=#0E1C30,fg=#1E3A5F]'
set -g @sf_time '#[bg=#0E1C30,fg=#1E3A5F]#[fg=#FFFFFF,bg=#1E3A5F] %H:%M #[fg=#1E3A5F,bg=#0E1C30]'
set -g @sf_sessioniconright '#[bg=#0E1C30,fg=#1E3A5F]#[fg=#00C16A,bg=#1E3A5F] 󱑼  '

#### --- Status Bar Styling --- ####
set -g status-position top

set -g status-left '#{E:@sf_sessioniconleft}#{E:@sf_sessionname}'
set -g status-left-length 100

set -g window-status-separator ''
set -g window-status-format '#[bg=#0E1C30,fg=#1E3A5F]#[fg=#94A3B8,bg=#1E3A5F] #W #[bg=#0E1C30,fg=#1E3A5F]'
set -g window-status-current-format '#[bg=#0E1C30,fg=#1E3A5F]#[fg=#FFC600,bold,bg=#1E3A5F] #W #[bg=#0E1C30,fg=#1E3A5F]'

set -g status-right '#{E:@sf_time}#[fg=#1E3A5F,bg=#0E1C30]#[fg=#FFFFFF,bg=#1E3A5F] 󰁹 #{battery_percentage} #[fg=#1E3A5F,bg=#0E1C30]#{E:@sf_sessioniconright}'
