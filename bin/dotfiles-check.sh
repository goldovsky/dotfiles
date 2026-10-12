#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────────────
# dotfiles-check.sh — report drift between this repo and the live system.
#
#   bin/dotfiles-check.sh            run every check
#   bin/dotfiles-check.sh --quiet    print only problems and the summary
#
# Strictly read-only: nothing is created, moved, linked or regenerated. Exit 1
# if at least one error is found, 0 otherwise. Warnings never fail the run.
#
# What it proves: the symlinks match what stow would produce, the generated
# colour files match a fresh generation from their preset, and the VS Code copy
# is not behind the editor.
#
# What it does NOT prove: that any config is *correct*, that tmux/nvim plugins
# are installed, or that a shell would actually start. Those need a real
# session, not a file comparison.
#
# Deliberately has no --fix. A fix for a broken symlink is `stow -t ~ <pkg>`,
# for a stale theme it is `theme <preset>`, and for VS Code it is `code-sync` —
# each is one command, and each deserves to be run knowingly.
# ─────────────────────────────────────────────────────────────────────────────

set -uo pipefail

REPO="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/.." && pwd -P)"
EXPECTED_REPO="${HOME}/git/dotfiles"
STOW_PACKAGES=(alacritty fastfetch ghostty nvim starship tmux)

QUIET=false
for arg in "$@"; do
    case "$arg" in
        --quiet|-q) QUIET=true ;;
        --help|-h) sed -n '2,22p' "$(readlink -f "${BASH_SOURCE[0]}")" | sed 's/^# \?//'; exit 0 ;;
        *) echo "dotfiles-check: unknown option: $arg" >&2; exit 2 ;;
    esac
done

if [ -t 1 ]; then
    RED=$'\033[0;31m'; GREEN=$'\033[0;32m'; YELLOW=$'\033[0;33m'
    BLUE=$'\033[0;34m'; BOLD=$'\033[1m'; DIM=$'\033[2m'; NC=$'\033[0m'
else
    RED=""; GREEN=""; YELLOW=""; BLUE=""; BOLD=""; DIM=""; NC=""
fi

errors=0
warnings=0

section() { printf '\n%s%s%s\n' "${BOLD}${BLUE}" "$1" "${NC}"; }
ok()   { "$QUIET" || printf '  %s=%s %s\n' "${GREEN}" "${NC}" "$1"; }
err()  { errors=$((errors + 1));   printf '  %s!%s %s\n' "${RED}" "${NC}" "$1"; }
warn() { warnings=$((warnings + 1)); printf '  %s?%s %s\n' "${YELLOW}" "${NC}" "$1"; }
hint() { printf '      %s%s%s\n' "${DIM}" "$1" "${NC}"; }

# Shorten $HOME to ~ so the output stays narrow.
tilde() { printf '%s' "${1/#${HOME}/\~}"; }

# ── 1. Repo location ─────────────────────────────────────────────────────────
# alacritty.toml, ghostty/config and generate-colors.sh all hardcode
# ~/git/dotfiles. Anywhere else and the colour imports resolve to nothing, so
# this is checked first and aborts: every later check would be noise.
section "1. Repo location"
if [ "$REPO" = "$EXPECTED_REPO" ]; then
    ok "$(tilde "$REPO")"
else
    err "repo is at $(tilde "$REPO"), expected $(tilde "$EXPECTED_REPO")"
    hint "alacritty.toml, ghostty/config and generate-colors.sh hardcode that path"
    printf '\n%sAborting: every other check would be misleading.%s\n' "${RED}" "${NC}"
    exit 1
fi

# ── 2. Stow packages ─────────────────────────────────────────────────────────
# Rather than reimplementing stow's folding rules, ask stow itself what it
# would still do. A clean package produces no action line at all.
section "2. Stow packages"
if ! command -v stow >/dev/null 2>&1; then
    err "stow is not installed (apt install stow)"
else
    for pkg in "${STOW_PACKAGES[@]}"; do
        actions="$(cd "$REPO" && stow -n -v -t "$HOME" "$pkg" 2>&1 \
            | grep -E '^(LINK|UNLINK|MKDIR|RMDIR|CONFLICT|ERROR)' || true)"
        if [ -z "$actions" ]; then
            ok "$pkg"
        else
            count="$(printf '%s\n' "$actions" | wc -l)"
            err "$pkg — ${count} pending action(s), run: stow -t ~ $pkg"
            printf '%s\n' "$actions" | head -5 | while IFS= read -r line; do hint "$line"; done
            [ "$count" -gt 5 ] && hint "... and $((count - 5)) more"
        fi
    done
fi

# ── 3. Hand-made symlinks ────────────────────────────────────────────────────
# shell/ cannot be stowed: its layout is shell/<shell>/..., so `stow -t ~ shell`
# would create ~/bash, ~/zsh and ~/common. These links are made by hand and are
# therefore the ones most likely to be silently replaced by an installer.
section "3. Hand-made symlinks (shell/)"
check_link() {
    local link="$1" want="$2"
    local shown; shown="$(tilde "$link")"
    if [ ! -e "$link" ] && [ ! -L "$link" ]; then
        err "${shown} is missing"
        hint "ln -s ${want} ${link}"
    elif [ ! -L "$link" ]; then
        err "${shown} is a real file, not a symlink into the repo"
        hint "mv ${shown} ${shown}.bak && ln -s ${want} ${link}"
    elif [ "$(readlink -f "$link")" != "$(readlink -f "$want")" ]; then
        err "${shown} -> $(readlink "$link"), expected ${want}"
    else
        ok "${shown}"
    fi
}
check_link "${HOME}/.bashrc"              "${REPO}/shell/bash/.bashrc"
check_link "${HOME}/.zshrc"               "${REPO}/shell/zsh/.zshrc"
check_link "${HOME}/.config/shell/bash"   "${REPO}/shell/bash/.config/bash"
check_link "${HOME}/.config/shell/common" "${REPO}/shell/common"

# ── 4. keyd ──────────────────────────────────────────────────────────────────
# readlink only: reading /etc needs no privilege, and a check that prompts for
# sudo is a check nobody runs.
section "4. keyd"
if ! dpkg -l keyd >/dev/null 2>&1; then
    warn "keyd is not installed (apt install keyd), skipping"
elif [ ! -L /etc/keyd/default.conf ]; then
    err "/etc/keyd/default.conf is not a symlink, run: keyd/install.sh"
elif [ "$(readlink -f /etc/keyd/default.conf)" != "${REPO}/keyd/keyd.conf" ]; then
    err "/etc/keyd/default.conf -> $(readlink /etc/keyd/default.conf), expected ${REPO}/keyd/keyd.conf"
else
    ok "/etc/keyd/default.conf"
fi

# ── 5. Generated theme ───────────────────────────────────────────────────────
# The preset is the source; outputs/ and the starship palette block are
# artefacts. Regenerating into a temp dir and diffing catches a preset edited
# without `theme <preset>` being re-run, which no symlink check would see.
section "5. Generated theme"
outputs="${REPO}/shell/common/themes/outputs"
preset="$(sed -n 's/^# Source: \(.*\)\.json$/\1/p' "${outputs}/tmux-colors.tmux" 2>/dev/null | head -1)"
if [ -z "$preset" ]; then
    err "cannot read the active preset from ${outputs}/tmux-colors.tmux"
elif [ ! -f "${REPO}/shell/common/themes/presets/${preset}.json" ]; then
    err "active preset '${preset}' has no presets/${preset}.json"
else
    tmpdir="$(mktemp -d)"
    trap 'rm -rf "$tmpdir"' EXIT
    if ! "${REPO}/shell/common/themes/generate-colors.sh" "$preset" --outdir "$tmpdir" >/dev/null 2>&1; then
        err "generate-colors.sh ${preset} failed"
    else
        stale=()
        for f in alacritty-theme.toml ghostty-theme tmux-colors.tmux; do
            diff -q "${tmpdir}/${f}" "${outputs}/${f}" >/dev/null 2>&1 || stale+=("outputs/${f}")
        done
        diff -q "${tmpdir}/starship.toml" "${REPO}/starship/.config/starship/starship.toml" \
            >/dev/null 2>&1 || stale+=("starship.toml palette block")
        if [ ${#stale[@]} -eq 0 ]; then
            ok "preset '${preset}' — 4 artefacts up to date"
        else
            err "stale, run: theme ${preset}"
            for f in "${stale[@]}"; do hint "$f"; done
        fi
    fi
fi

# ── 6. VS Code ───────────────────────────────────────────────────────────────
# Direction is live -> repo: settings are edited in the editor, so the editor
# wins and the repo is what goes stale. Reuses code-sync's own --check.
section "6. VS Code"
code_sync="${REPO}/shell/common/scripts/code-sync.sh"
if [ ! -f "${HOME}/.config/Code/User/globalStorage/storage.json" ]; then
    warn "VS Code not installed on this machine, skipping"
elif out="$("$code_sync" --check 2>&1)"; then
    ok "profile in sync with the repo"
else
    err "repo is behind the editor, run: code-sync"
    printf '%s\n' "$out" | grep -E 'differs|not found|no profile' | while IFS= read -r l; do hint "$l"; done
fi

# ── 7. Machine-local files ───────────────────────────────────────────────────
# Unversioned by design. Every consumer guards them with [ -f ], so a missing
# one degrades silently rather than breaking — which is exactly why it is worth
# naming here.
section "7. Machine-local files (unversioned)"
check_local() {
    if [ -e "$1" ]; then ok "$(tilde "$1")  ${DIM}— $2${NC}"
    else warn "$(tilde "$1") is missing  ${DIM}— $2${NC}"; fi
}
check_local "${HOME}/.bashrc_local"               "conda/mamba init"
check_local "${HOME}/.bashrc_work"                "work env, bash"
check_local "${HOME}/.zshrc_work"                 "work env, zsh"
check_local "${HOME}/.config/tmux/local.tmux"     "dev container, sessionizer roots"
check_local "${REPO}/shell/common/zb.conf"        "project list for zb"

# ── 8. Dependencies ──────────────────────────────────────────────────────────
# Debian renames two of these to avoid a name clash, so each entry is a list of
# acceptable binaries. zb.sh probes for batcat/bat the same way.
section "8. Dependencies"
missing=()
for spec in git stow tmux fzf rg nvim "batcat|bat" zoxide atuin starship lazygit fastfetch; do
    found=false
    IFS='|' read -ra names <<< "$spec"
    for name in "${names[@]}"; do
        command -v "$name" >/dev/null 2>&1 && { found=true; break; }
    done
    "$found" || missing+=("${names[0]}")
done
if [ ${#missing[@]} -eq 0 ]; then
    ok "all present"
else
    warn "missing: ${missing[*]}"
fi
if command -v fdfind >/dev/null 2>&1 || command -v fd >/dev/null 2>&1; then
    ok "fd present (optional)"
else
    warn "fd is absent — optional, the nvim picker falls back to ripgrep"
fi

# ── Summary ──────────────────────────────────────────────────────────────────
printf '\n'
if [ "$errors" -eq 0 ] && [ "$warnings" -eq 0 ]; then
    printf '%sNo drift.%s\n' "${GREEN}${BOLD}" "${NC}"
elif [ "$errors" -eq 0 ]; then
    printf '%sNo drift%s, %d warning(s).\n' "${GREEN}${BOLD}" "${NC}" "$warnings"
else
    printf '%s%d error(s)%s, %d warning(s).\n' "${RED}${BOLD}" "$errors" "${NC}" "$warnings"
fi
printf '%sChecks links and generated files, not whether a config is correct.%s\n' "${DIM}" "${NC}"

[ "$errors" -eq 0 ]
