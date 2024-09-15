# CUSTOM SCRIPTS
## make executable
chmod +x ~/.config/bash/scripts/weather.sh
chmod +x ~/.config/bash/scripts/run.sh
chmod +x ~/.config/bash/scripts/git-create-branch.sh

source ~/.config/bash/scripts/runAutoCompletion.sh
alias run="~/.config/bash/scripts/./run.sh"
alias gcb="sh ~/.config/bash/scripts/git-create-branch.sh"

alias sudoidea="sudo /snap/bin/intellij-idea-community"

alias kill3000="fuser -k 3000/tcp"
## give id of process on port 3000
# sudo sudo lsof -t -i:3000
## kill process of id 1234
# sudo kill -9 1234
# alias jj="pbpaste | jsonpp | pbcopy"

# Navigation
alias ll="ls -1"
alias la="ls -la"

# Tools
alias bat="batcat"

# Weather
alias wttr="curl wttr.in"
alias weather=". ~/.config/bash/scripts/weather.sh"

# Edit
# note: either do a editconf script, or one to simlink everything
# alias vimac="vim ~/.config/alacritty/alacritty.yml"
# alias vimbrc="vim ~/.bashrc"
# alias vimbrca="vim ~/.bashrc_aliases"
# alias bat="batcat" # https://github.com/sharkdp/bat

# GIT
alias gpr="git pull --rebase"
## "git rebase develop"
alias grbd="git pull origin develop --rebase"
## "git delete other branches"
alias gdob="git branch | grep -v ^* | xargs git branch -D" # delete all local branches except current one

## same as above but allow to give a list for a partial match
# keep_list="master 2247"; git branch | grep -v ^* | grep -Ev "$(echo $keep_list | sed -e 's/[[:blank:]]/|/g')" | xargs -n 1 git branch -D


# To turn on ZSH by default
# exec zsh
# reload tmux config
alias rtmux="tmux source-file ~/.tmux.conf"
# Set up fzf key bindings and fuzzy completion
# eval "$(fzf --bash)" #  need fzf 0.48.0 or later
# starship
export STARSHIP_CONFIG=~/.config/starship/starship.toml
eval "$(starship init bash)"
## Atuin
# . "$HOME/.atuin/bin/env"
# [[ -f ~/.bash-preexec.sh ]] && source ~/.bash-preexec.sh
# eval "$(atuin init bash)"

