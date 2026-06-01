#!/usr/bin/env bash
# =============================================================================
# Git Bare Clone — Shell Function
# =============================================================================
#
# Clones a repository as a bare repo and sets up the initial worktree.
#
# Structure created:
#   <cwd>/<repo>/
#   ├── .bare/                    # bare clone
#   └── <default-branch>@<repo>/ # initial worktree
#
# USAGE
# -----
#   gbclone <url>   Clone a repo using bare method with worktree setup
#                   e.g. gbclone git@github.com:ajeetdsouza/zoxide.git
#
# =============================================================================

gbclone() {
    if [[ -z "$1" ]]; then
        echo "Usage: gbclone <git-url>"
        echo "  e.g. gbclone git@github.com:ajeetdsouza/zoxide.git"
        return 1
    fi

    local url="$1"

    # Extract repo name from URL (handles SSH and HTTPS, strips .git suffix)
    local repo_name
    repo_name=$(basename "$url" .git)

    if [[ -z "$repo_name" ]]; then
        echo "Error: could not extract repo name from URL" >&2
        return 1
    fi

    if [[ -d "$repo_name" ]]; then
        echo "Error: directory '$repo_name' already exists" >&2
        return 1
    fi

    # Create repo directory and bare clone into .bare
    mkdir "$repo_name" || return 1
    git clone --bare "$url" "$repo_name/.bare" || { rm -rf "$repo_name"; return 1; }

    # Detect default branch from HEAD
    local default_branch
    default_branch=$(git --git-dir="$repo_name/.bare" symbolic-ref --short HEAD 2>/dev/null)

    if [[ -z "$default_branch" ]]; then
        echo "Error: could not detect default branch" >&2
        rm -rf "$repo_name"
        return 1
    fi

    # Create initial worktree (use relative path for portability)
    local worktree_name="${default_branch}@${repo_name}"
    git -C "$repo_name/.bare" worktree add "../$worktree_name" "$default_branch" || {
        rm -rf "$repo_name"
        return 1
    }

    local green='\033[0;32m'
    local cyan='\033[0;36m'
    local dim='\033[2m'
    local reset='\033[0m'

    echo ""
    echo -e "${green}Bare clone ready${reset}"
    echo -e "${dim}──────────────────────────────────────${reset}"
    echo -e "  Repo:     ${cyan}$(pwd)/$repo_name${reset}"
    echo -e "  Bare:     ${dim}$(pwd)/$repo_name/.bare${reset}"
    echo -e "  Worktree: ${cyan}$worktree_name${reset} ${dim}(branch: $default_branch)${reset}"
    echo ""

    cd "$repo_name/$worktree_name" || return 1
}
