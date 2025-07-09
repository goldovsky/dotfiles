source ~/.config/bash/scripts/tools.sh
# CUSTOM SCRIPTS
## make executable
chmod +x ~/.config/bash/scripts/weather.sh
chmod +x ~/.config/bash/scripts/run.sh
chmod +x ~/.config/bash/scripts/git-create-branch.sh

source ~/.config/bash/scripts/runAutoCompletion.sh
alias run="~/.config/bash/scripts/./run.sh"
alias gcb="sh ~/.config/bash/scripts/git-create-branch.sh"

alias sudoidea="sudo /snap/bin/intellij-idea-community"

# System
alias killProcess="fuser -k $1/tcp"         # kill process running on $1
alias whatProcess="sudo sudo lsof -t -i:$1" # give id of process on port $1 (ex:3000)
alias killProcessId="sudo kill -9 $1"       # kill process of id $1 (ex:1234)

# Navigation
alias ll="ls -1 --group-directories-first"
# alias l="exa --icons --group-directories-first --color-scale"
alias la="ls -la --group-directories-first"

# Shortcuts
alias c="clear"
alias e="exit"
alias ff="fastfetch"
alias q="exit"
# alias v="nvim"
# alias vim="nvim"
alias aliases="alias | fzf"

# Tools
alias bat="batcat"
alias cat="batcat -pp -n"
alias less='batcat --paging=always'
alias vm="virtualbox"
alias lg="lazygit"
alias fmr='/home/fvlb5625/git/code/testFormatedMessageScript/format_mr.sh'

# IA
alias codellama="ollama run codellama"

# Youtube DDL
# If you want a higher bitrate for youtube-dl extracted audio. 
# youtube-dl -x --audio-format mp3 --audio-quality 320k  -o '%(title)s.%(ext)s' $url
alias ytmp3='youtube-dl -ciw -o "%(title)s.%(ext)s" --extract-audio --audio-format mp3'
alias ytvid='youtube-dl -ciw --format mp4 -o "%(title)s.%(ext)s"'

# Weather
alias wttr="curl wttr.in/roubaix" # /$1 ?
alias weather=". ~/.config/bash/scripts/weather.sh"

# GIT
## shortcuts
alias g='git'
alias gs="git status"
alias gb="git branch"
alias gl="git log --all --graph --decorate --oneline"
alias gpullr="git pull --rebase"
alias gp="git push origin HEAD"

## actions
alias gcbranch="git branch | grep {$1} | xargs git checkout"
alias grbd="git pull origin develop --rebase"                  # "git rebase develop"
alias gdob="git branch | grep -v ^* | xargs git branch -D"     # "git delete other branches", delete all local branches except current one
## same as above but allow to give a list for a partial match
# keep_list="master 2247"; git branch | grep -v ^* | grep -Ev "$(echo $keep_list | sed -e 's/[[:blank:]]/|/g')" | xargs -n 1 git branch -D

# To turn on ZSH by default
# exec zsh
# reload tmux config
alias rtmux="tmux source-file ~/.tmux.conf"
# Set up fzf key bindings and fuzzy completion
# eval "$(fzf --bash)" #  need fzf 0.48.0 or later

# Starship
export STARSHIP_CONFIG=~/.config/starship/starship.toml
eval "$(starship init bash)"

# Atuin
. "$HOME/.atuin/bin/env"
[[ -f ~/.bash-preexec.sh ]] && source ~/.bash-preexec.sh
eval "$(atuin init bash)"

# Ideas
# alias jj="pbpaste | jsonpp | pbcopy"

export BAT_CONFIG_PATH="/~/.config/bash/bat/bat.conf"
