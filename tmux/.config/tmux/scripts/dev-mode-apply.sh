#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────────────
# dev-mode-apply.sh — switch EXISTING panes into or out of the dev container.
#
# Usage: dev-mode-apply.sh on|off <current-pane-id>
#
# Why this exists: a pane runs whatever command it was created with, so the
# split bindings alone only cover NEW panes. An already open pane has to be
# respawned, which replaces its process — and kills whatever runs in it.
#
# Scope comes from the @docker_mode_scope tmux option:
#   window (default) — every pane of the current window, matching @docker_mode
#                      which is itself a window option
#   pane             — the current pane only
# There is deliberately no "session" scope: docker-mode is per window so that a
# brand new window still gives a plain host shell.
#
# Safety rule: only idle panes are switched. A pane running a server, a build or
# an editor is left alone — killing it would leave an orphan in the container.
#
# The pane id is passed as an argument: `run-shell` does expand #{...} formats
# (hence #{pane_id} in the binding) but does NOT export TMUX_PANE.
# ─────────────────────────────────────────────────────────────────────────────

mode="${1:-}"
pane="${2:-}"

[ -n "${mode}" ] && [ -n "${pane}" ] || exit 0

scope="$(tmux show -gv @docker_mode_scope 2>/dev/null)"
case "${scope}" in
    pane) panes="${pane}" ;;
    *)    scope="window"
          panes="$(tmux list-panes -t "${pane}" -F '#{pane_id}' 2>/dev/null)" ;;
esac

# `run-shell` executes this script under /bin/sh, so $SHELL would be /bin/sh.
# Read default-shell instead: that is what tmux uses for a regular pane.
host_shell="$(tmux show -gv default-shell 2>/dev/null)"
host_shell="${host_shell:-/bin/bash}"

# How long to wait for the container shell to exit, in 0.15s steps. An idle
# shell exits almost immediately; the full delay is only spent on busy panes.
exit_wait_steps=12

converted=0
skipped=0

for p in ${panes}; do
    cmd="$(tmux display -p -t "${p}" '#{pane_current_command}' 2>/dev/null)"
    path="$(tmux display -p -t "${p}" '#{pane_current_path}' 2>/dev/null)"

    case "${mode}:${cmd}" in
        # Idle host shell -> container.
        on:bash | on:zsh | on:sh | on:fish | on:-bash | on:-zsh)
            tmux respawn-pane -k -t "${p}" -c "${path}" \
                "${HOME}/.config/tmux/scripts/dev-shell.sh" 2>/dev/null \
                && converted=$((converted + 1))
            ;;

        # Container pane -> host shell.
        #
        # The pane is not killed: Ctrl-D is sent to the container shell instead.
        #   - idle  : it exits cleanly, leaving NO orphan process behind
        #             (which `respawn-pane -k` would do)
        #   - busy  : the running command swallows the Ctrl-D, the shell stays
        #             alive, and the pane is left untouched
        # `remain-on-exit` keeps the pane alive once the shell is gone, long
        # enough to relaunch it on the host; #{pane_dead} is the verdict.
        #
        # This is the only reliable method here: inside this container
        # /proc/PID/environ is unreadable even as root and ps reports PPID=0, so
        # neither an environment marker nor a process tree can tell us whether
        # the pane is busy.
        off:docker)
            tmux set -p -t "${p}" remain-on-exit on 2>/dev/null
            tmux send-keys -t "${p}" C-d 2>/dev/null

            dead=0
            i=0
            while [ "${i}" -lt "${exit_wait_steps}" ]; do
                if [ "$(tmux display -p -t "${p}" '#{pane_dead}' 2>/dev/null)" = "1" ]; then
                    dead=1
                    break
                fi
                i=$((i + 1))
                sleep 0.15
            done

            if [ "${dead}" = 1 ]; then
                tmux respawn-pane -t "${p}" -c "${path}" "${host_shell} -l" 2>/dev/null \
                    && converted=$((converted + 1))
            else
                skipped=$((skipped + 1))
            fi

            tmux set -p -t "${p}" -u remain-on-exit 2>/dev/null
            ;;

        # Already in the wanted state: nothing to do, and not counted as skipped.
        on:docker | off:bash | off:zsh | off:sh | off:fish | off:-bash | off:-zsh)
            ;;

        # Busy pane: left untouched.
        *)
            skipped=$((skipped + 1))
            ;;
    esac
done

# Kept short: this overlays the status bar. Only the count of panes left behind
# is worth reporting, since not converting them is otherwise invisible.
msg="docker-mode $(echo "${mode}" | tr '[:lower:]' '[:upper:]')"
if [ "${skipped}" -gt 0 ]; then
    msg="${msg} — ${skipped} busy pane(s) skipped"
fi
tmux display-message "${msg}"
