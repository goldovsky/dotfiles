source ~/.config/shell/common/git/git.sh
source ~/.config/shell/common/aliases/icons.sh
source ~/.config/shell/common/scripts/tmuxInit.sh

alias run="~/.config/shell/common/scripts/./run.sh"

# alias sudoidea="sudo /snap/bin/intellij-idea-community"

# System
alias killProcess="fuser -k $1/tcp"         # kill process running on $1
alias whatProcess="sudo sudo lsof -t -i:$1" # give id of process on port $1 (ex:3000)
alias killProcessId="sudo kill -9 $1"       # kill process of id $1 (ex:1234)

# Navigation
alias ll="ls -1 --group-directories-first"
alias la="ls -la --group-directories-first"
# alias l="eza --icons --group-directories-first --color-scale"
# eza --tree --level=2 --icons

# Shortcuts
alias c="clear"
alias e="exit"
alias q="exit"
alias ff="fastfetch"
alias aliases="alias | fzf"

# Tools
alias bat="batcat"
alias cat="batcat -pp -n"
alias less='batcat --paging=always'
alias vm="virtualbox"
alias fmr='/home/fvlb5625/git/sandbox/scripts/formatMergeRequest.sh'
# alias v="nvim"
# alias vim="nvim"
alias nv="nvim"

# IA
alias codellama="ollama run codellama"
alias oc="opencode"
alias Œ="opencode"

# Youtube DDL
# If you want a higher bitrate for youtube-dl extracted audio.
# youtube-dl -x --audio-format mp3 --audio-quality 320k  -o '%(title)s.%(ext)s' $url
alias ytmp3='youtube-dl -ciw -o "%(title)s.%(ext)s" --extract-audio --audio-format mp3'
alias ytvid='youtube-dl -ciw --format mp4 -o "%(title)s.%(ext)s"'

# Weather
alias wttr="curl wttr.in/roubaix" # /$1 ?
alias weather=". ~/.config/shell/common/scripts/weather.sh"


# To turn on ZSH by default
# exec zsh
# Set up fzf key bindings and fuzzy completion
# eval "$(fzf --bash)" #  need fzf 0.48.0 or later
