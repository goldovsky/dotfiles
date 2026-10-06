# Common shell config
source ~/.config/shell/common/env/path.sh
source ~/.config/shell/common/aliases/global.sh
source ~/.config/shell/common/scripts/tools.sh

# CUSTOM SCRIPTS
# (no chmod here: the exec bit is tracked in git as mode 100755)

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
# eval "$(zoxide init --cmd cd zsh)"

# Atuin
. "$HOME/.atuin/bin/env"
eval "$(atuin init zsh)"

# Personal aliases from bash
if [ -f ~/goldovskyBash/.bashrc_goldovsky ]; then
    . ~/goldovskyBash/.bashrc_goldovsky
fi

# Work aliases (unversioned, same convention as ~/.bashrc_work).
# The Callbot block used to be inlined above: it was a stale copy of what
# ~/.bashrc_work already defines, and its runDevContainer.sh path
# (cb-docker/dev/) no longer exists — the real one is cb-docker/bin/local/.
if [ -f ~/.zshrc_work ]; then
    . ~/.zshrc_work
fi

# Force Electron apps (VS Code) to X11: native Wayland breaks keyboard layouts (Ctrl+Z resolved as Ctrl+W)
export ELECTRON_OZONE_PLATFORM_HINT=x11
