source ~/.config/bash/scripts/tools.sh
# CUSTOM SCRIPTS
## make executable
chmod +x ~/.config/bash/scripts/weather.sh
chmod +x ~/.config/bash/scripts/run.sh
chmod +x ~/.config/bash/scripts/git-create-branch.sh

source ~/.config/bash/scripts/runAutoCompletion.sh
source ~/.config/bash/aliases/global.sh

# Starship
export STARSHIP_CONFIG=~/.config/starship/starship.toml
eval "$(starship init bash)"

# Atuin
if [ -f ~/.bash-preexec.sh ]; then
    . "$HOME/.atuin/bin/env"
    [[ -f ~/.bash-preexec.sh ]] && source ~/.bash-preexec.sh
    eval "$(atuin init bash)"
fi

# Ideas
# alias jj="pbpaste | jsonpp | pbcopy"

export BAT_CONFIG_PATH="/~/.config/bash/bat/bat.conf"
