# dotfiles

Config for a Linux workstation: Alacritty + tmux + bash, Neovim and VS Code as
editors, and a tmux "docker-mode" for working inside a dev container.

## Layout

| Package | Target | Managed by |
|---|---|---|
| `alacritty` | `~/.config/alacritty/` | stow |
| `fastfetch` | `~/.config/fastfetch/` | stow |
| `ghostty` | `~/.config/ghostty/` | stow |
| `nvim` | `~/.config/nvim/` | stow |
| `starship` | `~/.config/starship/` | stow |
| `tmux` | `~/.tmux.conf`, `~/.config/tmux/` | stow |
| `shell` | `~/.bashrc`, `~/.zshrc`, `~/.config/shell/` | **by hand**, see below |
| `keyd` | `/etc/keyd/` | `keyd/install.sh` |
| `vscode` | VS Code profile dir | **copied**, see `vscode/README.md` |

```bash
# from this directory, for the stow packages
stow -t ~ alacritty fastfetch ghostty nvim starship tmux

# adopt an existing file into the repo instead of refusing to link
stow -t ~ --adopt <package>
```

> **`shell/` is not stow-compatible.** Its layout is `shell/<shell>/...`, so
> `stow -t ~ shell` creates `~/bash`, `~/zsh` and `~/common` rather than the
> intended targets. `~/.bashrc`, `~/.zshrc` and `~/.config/shell/{bash,common}`
> are therefore symlinked by hand. Restructuring it is part of the
> install-script TODO.

## Checking

```bash
dotcheck          # or: bin/dotfiles-check.sh
dotcheck --quiet  # only problems
```

Read-only; exits 1 on drift. Reports broken or missing symlinks, stow packages
that are not fully linked, colour files that no longer match their preset, a
VS Code profile the repo is behind on, missing machine-local files and missing
dependencies. It compares links and files — it does not prove a config is
correct. `AGENTS.md` carries the invariants it enforces.

## Machine-local files

Nothing secret is committed. Machine-specific values live outside the repo and
are sourced only when present:

| File | Holds |
|---|---|
| `~/.bashrc_local` | conda/mamba init, anything an installer rewrites |
| `~/.bashrc_work` / `~/.zshrc_work` | work env and aliases (`cbdev`, `CALLBOT_SOURCE`…) |
| `~/goldovskyBash/.bashrc_goldovsky` | personal aliases |
| `~/.config/tmux/local.tmux` | dev container name, paths, sessionizer roots |
| `shell/common/zb.conf` | project list for `zb` (gitignored, has a `.example`) |

Keeping conda out of `~/.bashrc` matters: `conda init` appends to that file,
which is what silently replaced the symlink before.

## Shell

bash is the login shell. `~/.bashrc` sources `~/.config/shell/bash/bashrc`,
which pulls in the shared layer in `shell/common/`:

- `aliases/` — general aliases, nerd-font icon vars
- `git/` — git aliases, `gcb` branch creation, `gw*` worktree helpers
- `scripts/` — `zb` (fuzzy file/content search), `tmx`, `run`, `md2pdf`,
  `weather`, `code-sync`
- `themes/` — palette generator, see below
- `env/` — PATH

conda is lazy-loaded, so startup is ~260 ms rather than ~600 ms. That cost is
paid once per tmux pane, which is why it is worth it.

## Themes

`shell/common/themes/generate-colors.sh <preset>` reads `presets/<preset>.json`
and writes Alacritty, Ghostty, tmux, Starship and OpenCode colours. Presets:
`cobalt2`, `cobalt2-light`, `nuxt` (current).

```bash
theme nuxt   # regenerates and reloads tmux
```

`--outdir <dir>` generates into a directory instead of the live locations and
touches nothing else; `dotcheck` uses it to diff a fresh generation against the
committed outputs.

Not covered by the generator: Neovim (`cobalt.nvim`) and VS Code (Cobalt2
theme). These are aligned by hand.

## tmux

See `tmux/README.md` — prefix is `Ctrl+Space`, `prefix + f` is the project
sessionizer, `prefix + C-d` toggles docker-mode.

## Software

Installed: git, lazygit, gnu stow, alacritty, starship, tmux, fzf, ripgrep,
neovim (LazyVim), bat, zoxide, atuin, keyd, fastfetch.

Worth checking: `tldr`, `eza`, `jq`, `broot`, `yt-dlp`, `fd` (Neovim's health
check asks for it).

## Fonts

ZedMono Nerd Font, size 14, across Alacritty, Ghostty and VS Code.
