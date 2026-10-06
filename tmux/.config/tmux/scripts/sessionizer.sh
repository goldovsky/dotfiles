#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────────────
# sessionizer.sh — fzf project picker that maps one git repo to one tmux session.
#
# Bound to prefix + f, run inside a display-popup.
#
# Finds every git repo (plain checkout, worktree, or bare-clone worktree) under
# the roots in @sessionizer_paths, lets fzf pick one, and attaches to a session
# named after it — creating that session only if it does not already exist.
# Picking the same project twice switches to it instead of spawning a duplicate,
# which is the part `tmx` never did.
#
# Config, from ~/.config/tmux/local.tmux (not versioned):
#   set -g @sessionizer_paths "~/git ~/work"   # default: ~/git
#   set -g @sessionizer_depth "5"              # default: 5
# ─────────────────────────────────────────────────────────────────────────────

set -u

tmux_opt() {
    local value
    value="$(tmux show-option -gqv "$1" 2>/dev/null)"
    [ -n "${value}" ] && printf '%s' "${value}" || printf '%s' "$2"
}

roots_raw="$(tmux_opt '@sessionizer_paths' "${HOME}/git")"
depth="$(tmux_opt '@sessionizer_depth' '5')"

# Expand ~ and any $VARS in the configured roots, then keep the ones that exist.
roots=()
for root in ${roots_raw}; do
    eval "root=${root}"
    [ -d "${root}" ] && roots+=("${root}")
done

if [ ${#roots[@]} -eq 0 ]; then
    echo "sessionizer: no valid path in @sessionizer_paths (${roots_raw})" >&2
    read -r -n 1 -s -p "press any key"
    exit 1
fi

# A git repo has a .git entry: a directory for a normal clone, a FILE for a
# worktree. -name matches both, so worktrees are picked up for free.
# node_modules is pruned because it is both huge and never interesting here.
list_projects() {
    find "${roots[@]}" -maxdepth "${depth}" \
        \( -name node_modules -o -name .venv -o -name .bare \) -prune \
        -o -name .git -print 2>/dev/null |
        sed 's|/\.git$||' |
        sort -u
}

selected="$(list_projects | sed "s|^${HOME}/|~/|" |
    fzf --prompt='project > ' \
        --header='enter: switch/create session   esc: cancel' \
        --height=100% --reverse --border=none)"

[ -n "${selected}" ] || exit 0

# Back to an absolute path for tmux.
path="${selected/#\~\//${HOME}/}"
[ -d "${path}" ] || exit 0

# tmux treats dots and colons as session:window.pane separators, so they cannot
# appear in a session name.
name="$(basename "${path}" | tr '.:' '__')"

if ! tmux has-session -t="${name}" 2>/dev/null; then
    tmux new-session -d -s "${name}" -c "${path}"
fi

# switch-client works from inside tmux (the popup case); attach-session is the
# fallback when the script is run from a bare shell.
if [ -n "${TMUX:-}" ]; then
    tmux switch-client -t "${name}"
else
    tmux attach-session -t "${name}"
fi
