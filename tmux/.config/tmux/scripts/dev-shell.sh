#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────────────
# dev-shell.sh — open a shell inside the dev container.
#
# Used as the command of panes created while docker-mode is on, and by
# dev-mode-apply.sh when converting an existing pane. Since the `docker exec`
# becomes the pane's root process, a single Ctrl-D closes both the container
# shell and the pane.
#
# Configuration is read from tmux options (~/.config/tmux/local.tmux), which
# keeps this script generic.
# ─────────────────────────────────────────────────────────────────────────────

opt() { tmux show -gv "$1" 2>/dev/null; }

container="$(opt @dev_container)"
user="$(opt @dev_user)"
host_root="$(opt @dev_host_root)"
container_root="$(opt @dev_container_root)"

fallback() {
    # Fall back to a host shell rather than letting the pane die instantly,
    # which would look like a split that silently vanishes.
    printf '\033[33m⚠ %s\033[0m\n' "$1"
    exec "${SHELL:-/bin/bash}" -l
}

[ -n "${container}" ] || fallback "No @dev_container configured — host shell."
command -v docker >/dev/null 2>&1 || fallback "docker not found — host shell."

if ! docker ps --filter "name=^${container}$" --format '{{.Names}}' 2>/dev/null | grep -q .; then
    fallback "Container ${container} is down — host shell. (prefix + C-u to start the stack)"
fi

# Translate the host working directory to its container counterpart through the
# mounted volume. Outside the mounted tree, fall back to the container root.
workdir="${container_root:-/}"
if [ -n "${host_root}" ]; then
    case "${PWD}" in
        "${host_root}") workdir="${container_root}" ;;
        "${host_root}"/*) workdir="${container_root}${PWD#"${host_root}"}" ;;
    esac
fi

# If the directory does not exist container-side, `docker exec -w` would fail:
# fall back to the root rather than losing the pane.
if ! docker exec "${container}" test -d "${workdir}" 2>/dev/null; then
    workdir="${container_root:-/}"
fi

# `exec` is deliberate: the docker exec becomes the pane's root process, so one
# Ctrl-D closes the container shell AND the pane. Without it you would have to
# exit twice — exactly what this mode is meant to avoid.
exec docker exec -it --user "${user:-root}" -w "${workdir}" "${container}" bash -l
