#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────────────
# code-sync.sh — copy the VS Code config of a profile into this repo.
#
#   code-sync.sh            sync the profile named by $VSCODE_PROFILE (Callbot)
#   code-sync.sh <name>     sync that profile
#   code-sync.sh --check    report drift, change nothing (exit 1 if drifted)
#
# Direction is always live -> repo: settings are edited in the editor, so the
# editor wins. This exists because the tracked copy silently fell seven months
# behind, and the profile directory is named after a per-profile hash, which
# makes a plain stow symlink non-portable.
# ─────────────────────────────────────────────────────────────────────────────

set -euo pipefail

user_dir="${HOME}/.config/Code/User"
storage="${user_dir}/globalStorage/storage.json"

# This script is reached through ~/.config/shell/common, a symlink into the
# repo, so the path has to be resolved physically before walking up to the root:
# scripts -> common -> shell -> repo root.
script_dir="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" && pwd -P)"
repo_dir="$(cd "${script_dir}/../../.." && pwd -P)/vscode"

check_only=false
profile="${VSCODE_PROFILE:-Callbot}"
for arg in "$@"; do
    case "${arg}" in
        --check) check_only=true ;;
        *) profile="${arg}" ;;
    esac
done

[ -f "${storage}" ] || { echo "code-sync: ${storage} not found" >&2; exit 1; }

# Resolve profile name -> directory hash.
location="$(python3 -c "
import json, sys
profiles = json.load(open('${storage}')).get('userDataProfiles', [])
for p in profiles:
    if p.get('name') == '${profile}':
        print(p['location']); break
")"

if [ -z "${location}" ]; then
    echo "code-sync: no profile named '${profile}'. Available:" >&2
    python3 -c "
import json
for p in json.load(open('${storage}')).get('userDataProfiles', []):
    print('  -', p.get('name'))" >&2
    exit 1
fi

profile_dir="${user_dir}/profiles/${location}"
drifted=false

sync_one() {
    local src="$1" dst="$2"
    [ -f "${src}" ] || return 0
    if [ -f "${dst}" ] && diff -q "${src}" "${dst}" >/dev/null 2>&1; then
        printf '  = %s\n' "$(basename "${dst}")"
        return 0
    fi
    drifted=true
    if "${check_only}"; then
        printf '  ! %s differs\n' "$(basename "${dst}")"
    else
        cp "${src}" "${dst}"
        printf '  > %s updated\n' "$(basename "${dst}")"
    fi
}

echo "profile '${profile}' (${location})"
sync_one "${profile_dir}/settings.json"      "${repo_dir}/settings.json"
sync_one "${profile_dir}/keybindings.json"   "${repo_dir}/keybindings.json"
sync_one "${user_dir}/settings.json"         "${repo_dir}/settings.default-profile.json"

if "${check_only}" && "${drifted}"; then
    echo "code-sync: repo is behind the editor; run without --check" >&2
    exit 1
fi
