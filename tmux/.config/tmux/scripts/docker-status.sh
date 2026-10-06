#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────────────
# docker-status.sh — container "up" dot for the tmux status bar.
#
# Usage: docker-status.sh <container> <up-colour>
#
# Called from stylings.tmux through #(...), refreshed every status-interval.
# tmux runs #() jobs in the background and `docker ps` costs ~25ms, so no cache
# is needed.
#
# Only the "up" state is rendered. Anything else — container stopped, missing,
# docker absent, or no container configured (machine without
# ~/.config/tmux/local.tmux) — prints nothing, leaving the status bar clean.
# ─────────────────────────────────────────────────────────────────────────────

container="${1:-}"
color_up="${2:-green}"

[ -n "${container}" ] || exit 0
command -v docker >/dev/null 2>&1 || exit 0

# --filter name=^...$ only lists RUNNING containers, so empty output means
# "missing or stopped" — nothing to display.
if docker ps --filter "name=^${container}$" --format '{{.Names}}' 2>/dev/null | grep -q .; then
    printf '#[fg=%s]●' "${color_up}"
fi
