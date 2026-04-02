# Common shell config
source ~/.config/shell/common/env/path.sh
source ~/.config/shell/common/aliases/global.sh
source ~/.config/shell/common/scripts/tools.sh

# CUSTOM SCRIPTS
chmod +x ~/.config/shell/common/scripts/weather.sh
chmod +x ~/.config/shell/common/scripts/run.sh
chmod +x ~/.config/shell/common/scripts/git-create-branch.sh

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

plugins=(git)

source $ZSH/oh-my-zsh.sh

# starship
export STARSHIP_CONFIG=~/.config/starship/starship.toml
eval "$(starship init zsh)"

# Zoxide
eval "$(zoxide init zsh)"

# Atuin
. "$HOME/.atuin/bin/env"
eval "$(atuin init zsh)"

# Callbot
export CALLBOT_SOURCE=~/git/callbot/src
export CALLBOT_DATA=~/git/callbot/data
alias cbs="cd ${CALLBOT_SOURCE}"
alias cbdev="${CALLBOT_SOURCE}/cb-docker/dev/runDevContainer.sh"
alias rundev="cd ${CALLBOT_SOURCE} && ${CALLBOT_SOURCE}/cb-docker/dev/runDevContainer.sh"
alias runo="cd src/cb-orchestrator && ./run.sh"
alias rune="cd src/evalia && ./run.sh"

# Personal aliases from bash
if [ -f ~/goldovskyBash/.bashrc_goldovsky ]; then
    . ~/goldovskyBash/.bashrc_goldovsky
fi

# Work aliases
if [ -f ~/.config/shell/zsh/.zshrc_work ]; then
    . ~/.config/shell/zsh/.zshrc_work
fi
