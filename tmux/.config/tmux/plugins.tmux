#### --- TPM Plugins --- ####
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'
set -g @plugin 'christoomey/vim-tmux-navigator'
set -g @plugin 'tmux-plugins/tmux-battery'

# Battery icons (Nerd Font) - the default emoji don't render in all fonts
set -g @batt_icon_status_charged '󱟢'
set -g @batt_icon_status_charging '󰂄'
set -g @batt_icon_status_discharging '󰁾'
set -g @batt_icon_status_attached '󱊣'
set -g @batt_icon_status_unknown '?'
