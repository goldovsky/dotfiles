#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────────────
# dev-up.sh — start the dev stack from tmux (prefix + C-u), without opening a
# shell inside the container.
#
# Why a wrapper instead of putting the command straight in the binding:
# `display-popup` does NOT expand #{...} formats. Passing "#{@dev_up_command}"
# handed the literal string to sh, where the leading '#' starts a comment — sh
# exited 0 immediately and the popup closed without doing anything. So the
# option is read here instead, like dev-shell.sh does.
# ─────────────────────────────────────────────────────────────────────────────

cmd="$(tmux show -gv @dev_up_command 2>/dev/null)"

if [ -z "${cmd}" ]; then
    printf '\033[31m✗ No @dev_up_command configured.\033[0m\n' >&2
    printf '  Set it in ~/.config/tmux/local.tmux\n' >&2
    # Non-zero exit: with `display-popup -EE` the popup stays open, so the
    # message is readable.
    exit 1
fi

# exec: the popup follows the command's exit status directly. -EE closes it on
# success and keeps it open on failure so the error can be read.
exec sh -c "${cmd}"
