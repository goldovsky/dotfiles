#!/usr/bin/env bash
# =============================================================================
# Git Worktrees — Shell Functions
# =============================================================================
#
# All worktrees are stored in: ~/git/worktrees/{repo-name}/{sanitized-branch}
# Branch names are sanitized for folder use: "/" is replaced with "-"
# Base branch is auto-detected (first of: develop, main, master)
#
# USAGE
# -----
#   gwl            List worktrees (name, branch, commit)
#   gwll           List worktrees with full path
#   gwcd           Switch to a worktree (fzf)
#   gwr            Remove a worktree (fzf, prevents removing current)
#   gwa <branch>   Create new worktree + new branch from base
#                   e.g. gaw feature/RCMTORCH-0101
#   gwab [branch]  Create worktree from existing remote branch (PR review)
#                   Without arg: fzf picker from remote branches
#
# =============================================================================

# --- Configuration -----------------------------------------------------------

GIT_WORKTREE_BASE="${HOME}/git/worktrees"

# --- Helpers -----------------------------------------------------------------

_gwt_repo_name() {
    local name
    name=$(git remote get-url origin 2>/dev/null | sed 's|.*/||; s|\.git$||')
    if [[ -z "$name" ]]; then
        name=$(basename "$(git rev-parse --show-toplevel 2>/dev/null)")
    fi
    echo "$name"
}

_gwt_base() {
    echo "${GIT_WORKTREE_BASE}/$(_gwt_repo_name)"
}

_gwt_sanitize() {
    echo "${1//\//-}"
}

_gwt_detect_base() {
    for branch in develop main master; do
        if git show-ref --verify --quiet "refs/heads/$branch" 2>/dev/null; then
            echo "$branch"
            return 0
        fi
    done
    echo "Error: no base branch found (looked for develop, main, master)" >&2
    return 1
}

# --- Functions ---------------------------------------------------------------

gwl() {
    git worktree list | awk '{
        path = $1
        commit = $2
        branch = $3
        gsub(/[\[\]]/, "", branch)
        n = split(path, parts, "/")
        name = parts[n]
        printf "%-20s %-30s %s\n", name, branch, commit
    }' | (echo "NAME BRANCH COMMIT"; cat) | column -t
}

gwll() {
    git worktree list | awk '{
        path = $1
        commit = $2
        branch = $3
        gsub(/[\[\]]/, "", branch)
        n = split(path, parts, "/")
        name = parts[n]
        printf "%s\t%s\t%s\t%s\n", name, branch, commit, path
    }' | (printf "NAME\tBRANCH\tCOMMIT\tPATH\n"; cat) | column -t -s $'\t'
}

gwa() {
    if [[ -z "$1" ]]; then
        echo "Usage: gaw <branch-name>"
        echo "  Creates a new branch from the base branch (develop/main/master)"
        return 1
    fi

    local branch="$1"
    local base
    base=$(_gwt_detect_base) || return 1

    local sanitized
    sanitized=$(_gwt_sanitize "$branch")
    local target
    target="$(_gwt_base)/${sanitized}"

    mkdir -p "$(_gwt_base)"

    git worktree add -b "$branch" "$target" "$base"

    if [[ $? -eq 0 ]]; then
        echo "Worktree created at: $target (branch '$branch' from '$base')"
        cd "$target" || return 1
    fi
}

gwab() {
    local branch="$1"

    if [[ -z "$branch" ]]; then
        git fetch --all --quiet
        branch=$(git branch -r | sed 's|^ *origin/||' | grep -v '^HEAD' \
            | fzf --header="Select remote branch")
        if [[ -z "$branch" ]]; then
            return 0
        fi
    fi

    local sanitized
    sanitized=$(_gwt_sanitize "$branch")
    local target
    target="$(_gwt_base)/${sanitized}"

    mkdir -p "$(_gwt_base)"

    git fetch origin "$branch" 2>/dev/null
    git worktree add "$target" "$branch"

    if [[ $? -eq 0 ]]; then
        echo "Worktree created at: $target (branch '$branch')"
        cd "$target" || return 1
    fi
}

gwcd() {
    local selection
    selection=$(git worktree list | awk '{
        path = $1
        branch = $3
        gsub(/[\[\]]/, "", branch)
        n = split(path, parts, "/")
        name = parts[n]
        printf "%-20s %-30s %s\n", name, branch, path
    }' | fzf --header="Select worktree" --with-nth=1,2 | awk '{print $NF}')

    if [[ -n "$selection" ]]; then
        cd "$selection" || return 1
    fi
}

gwr() {
    local current
    current=$(pwd -P)

    local selection
    selection=$(git worktree list | awk -v cur="$current" '{
        path = $1
        if (path == cur) next
        branch = $3
        gsub(/[\[\]]/, "", branch)
        n = split(path, parts, "/")
        name = parts[n]
        printf "%-20s %-30s %s\n", name, branch, path
    }' | fzf --header="Select worktree to remove" --with-nth=1,2 | awk '{print $NF}')

    if [[ -n "$selection" ]]; then
        git worktree remove "$selection" && git worktree prune
        echo "Removed: $selection"
    fi
}
