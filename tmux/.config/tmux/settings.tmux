# Enable mouse mode
set -g mouse on

set -sg terminal-overrides ",*:RGB"  # true color support
set -g escape-time 0  # disable delays on escape sequences
set -g repeat-time 1000  # increase "prefix-free" window

# # Start counting pane and window number at 1
set -g base-index 1
set -g pane-base-index 1
set -g renumber-windows on  # keep numbering sequential
