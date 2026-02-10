# Enable mouse mode
set -g mouse on

# true color support
set -g default-terminal "${TERM}"
set -sg terminal-overrides ",*:RGB"

set -g escape-time 0  # disable delays on escape sequences
set -g repeat-time 1000  # increase "prefix-free" window
set -g history-limit 10000

# Start counting pane and window number at 1
set -g base-index 1
set -g pane-base-index 1
set -g renumber-windows on  # keep numbering sequential

# Rrestore copy/paste on ubuntu 24.04
set -s set-clipboard external
set -s copy-command 'xsel -i -b'
