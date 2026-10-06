# VS Code

Config for the **Callbot** profile, which is the one actually in use —
`~/.config/Code/User/settings.json` only holds a few window settings and
`"window.newWindowProfile": "Callbot"`.

| File | Source |
|---|---|
| `settings.json` | `~/.config/Code/User/profiles/<hash>/settings.json` |
| `keybindings.json` | `~/.config/Code/User/profiles/<hash>/keybindings.json` |
| `settings.default-profile.json` | `~/.config/Code/User/settings.json` |

## Not stowed, on purpose

The profile directory is named after a hash VS Code generates per profile
(`-585a5bbe` here), so the path is not portable between machines and a plain
`stow` target would be wrong on the next one. The profile name to hash mapping
lives in `~/.config/Code/User/globalStorage/storage.json` under
`userDataProfiles`.

These files are therefore **copied, not symlinked**, which means they drift.
They were last re-imported from live on 2026-10-06, after the repo copy had
fallen seven months behind and lost, among other things, the `emeraldwalk.runonsave`
hook and the move from Gruvbox to Cobalt2.

Copy direction when syncing: **live → repo**. The editor is the source of
truth, since that is where settings are actually edited.
