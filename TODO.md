# TODO

- make an install script for all of them (cf install script on dev repo, or bootstrap.sh?)
  - should also restructure `shell/` so it is stow-compatible: today it stows to
    `~/bash`, `~/zsh`, `~/common` instead of `~/.bashrc` + `~/.config/shell/`,
    so those links are made by hand
- script for git : git yeet (gyeet): prettier/linter/commit -am/git push origin HEAD
- atuin doesn't reach previous history before the terminal is launched, to check
- install `fd` (neovim health check asks for it, speeds up the snacks picker)
- ghostty: background colour is hardcoded, so it desyncs on every theme change.
  Either add a ghostty target to generate-colors.sh or drop the package — it
  also launches zsh while alacritty launches bash.

## VS CODE

- ~~symlink files to local~~ — not possible: the profile directory is named
  after a per-profile hash, so the path is not portable. `code-sync` copies
  live → repo instead, and `code-sync --check` reports drift.
- no dev container settings, although `ms-azuretools.vscode-containers` is
  installed and the whole tmux layer targets `callbot_dev`
- `ctrl+d` is remapped to duplicate-line, which collides with the tmux
  docker-mode toggle (`prefix + C-d`) and with the container shell exit
- `vscodevim.vim` and `asvetliakov.vscode-neovim` are both installed but
  neither is configured — nothing is shared with the nvim setup
