# work aliases
if [ -f ~/.config/bash/.bashrc_work ]; then
    . ~/.config/bash/.bashrc_work
fi

# load up personal bash
if [ -f ~/.config/bash/.bashrc ]; then
    . ~/.config/bash/.bashrc
fi
export PATH=$HOME/.local/bin:$PATH

# opencode
export PATH=/home/fvlb5625/.opencode/bin:$PATH
