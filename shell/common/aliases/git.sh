source ~/.config/shell/common/aliases/gitWorktrees.sh
source ~/.config/shell/common/aliases/gitBareClone.sh

# GIT
## shortcuts
alias g='git'
alias gs="git status"
alias gb="git branch"
alias gl="git log --all --graph --decorate --oneline"
alias gpullr="git pull --rebase"
alias gp="git push origin HEAD"

## actions
# alias gcbranch="git branch | grep {$1} | xargs git checkout"
gci() { git checkout $(git branch | fzf); }
alias grbd="git pull origin develop --rebase"              # "git rebase develop"
alias gdob="git branch | grep -v ^* | xargs git branch -D" # "git delete other branches", delete all local branches except current one
## same as above but allow to give a list for a partial match
# keep_list="master 2247"; git branch | grep -v ^* | grep -Ev "$(echo $keep_list | sed -e 's/[[:blank:]]/|/g')" | xargs -n 1 git branch -D
