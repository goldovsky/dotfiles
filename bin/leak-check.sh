#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────────────
# leak-check.sh — refuse content that must not reach this public repository.
#
#   bin/leak-check.sh             scan files staged for commit (pre-commit use)
#   bin/leak-check.sh --all       scan every tracked file (dotcheck use)
#
# Exit 1 if a pattern matches, 0 otherwise.
#
# Why it exists: the repo is public but follows its owner across missions, and
# the opencode package sits right next to configs that hold provider URLs,
# client hostnames and tokens. A single careless `stow --adopt` or copy-paste
# would publish them.
#
# Two pattern sources:
#   - generic secret shapes, committed below (safe to publish);
#   - client-specific names, in ~/.config/dotfiles/leak-patterns, one ERE per
#     line, NOT committed: listing a client's hostname here would itself be
#     the leak this script prevents.
#
# Enable as a hook once per clone: git config core.hooksPath githooks
# ─────────────────────────────────────────────────────────────────────────────

set -euo pipefail

REPO="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/.." && pwd -P)"
LOCAL_PATTERNS="${HOME}/.config/dotfiles/leak-patterns"

GENERIC_PATTERNS=(
    '-----BEGIN [A-Z ]*PRIVATE KEY-----'
    '"(apiKey|api_key|token|password|secret)"[[:space:]]*:[[:space:]]*"[^"{][^"]{7,}"'
    'Bearer [A-Za-z0-9._~+/-]{16,}'
    'gh[pousr]_[A-Za-z0-9]{30,}'
    'glpat-[A-Za-z0-9_-]{20,}'
    'sk-[A-Za-z0-9_-]{20,}'
    'AKIA[0-9A-Z]{16}'
)

patterns=("${GENERIC_PATTERNS[@]}")
if [ -r "$LOCAL_PATTERNS" ]; then
    while IFS= read -r line; do
        [[ -z "$line" || "$line" == \#* ]] && continue
        patterns+=("$line")
    done < "$LOCAL_PATTERNS"
fi

grep_args=()
for p in "${patterns[@]}"; do grep_args+=(-e "$p"); done

cd "$REPO"
# This script holds the generic patterns themselves, so it would match itself.
exclude=(':!bin/leak-check.sh')
if [ "${1:-}" = "--all" ]; then
    hits="$(git grep -nIiE "${grep_args[@]}" -- . "${exclude[@]}" || true)"
else
    hits="$(git grep --cached -nIiE "${grep_args[@]}" -- . "${exclude[@]}" || true)"
fi

if [ -n "$hits" ]; then
    echo "leak-check: refusing, sensitive content found:" >&2
    printf '%s\n' "$hits" | cut -c1-160 >&2
    echo "Move it to a machine-local file or ~/.secrets." >&2
    exit 1
fi
[ -r "$LOCAL_PATTERNS" ] || echo "leak-check: note, no $LOCAL_PATTERNS (client names not checked)" >&2
exit 0
