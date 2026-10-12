# TODO

- make an install script for all of them (cf install script on dev repo, or bootstrap.sh?)
  - should also restructure `shell/` so it is stow-compatible: today it stows to
    `~/bash`, `~/zsh`, `~/common` instead of `~/.bashrc` + `~/.config/shell/`,
    so those links are made by hand
- script for git : git yeet (gyeet): prettier/linter/commit -am/git push origin HEAD
- atuin doesn't reach previous history before the terminal is launched, to check
- ~~install `fd`~~ — already installed as `fdfind` (the Debian name, package
  `fd-find`). Nothing to do; `dotcheck` probes both names.
- ghostty launches zsh while alacritty launches bash and bash is the login
  shell. Pick one. (Colours are generated now.)
- `~/.zshrc` is now symlinked to the repo, but `~/.zshrc_work` does not exist,
  so zsh has no Callbot aliases. Create it if zsh is kept — note the old inline
  block pointed at `cb-docker/dev/runDevContainer.sh`, which no longer exists;
  the real path is `cb-docker/bin/local/`.

## VS CODE

- ~~symlink files to local~~ — not possible: the profile directory is named
  after a per-profile hash, so the path is not portable. `code-sync` copies
  live → repo instead, and `code-sync --check` reports drift.
- no dev container settings, although `ms-azuretools.vscode-containers` is
  installed and the whole tmux layer targets `callbot_dev`
- `ctrl+d` is remapped to duplicate-line. Checked: this does NOT collide with
  the tmux docker-mode toggle (that one is `prefix` + `C-d`, and tmux has no
  root-table `C-d`) nor with the container shell exit (the `when` clause is
  `editorTextFocus`, so the integrated terminal still gets EOF). The only
  consequence is that VS Code's default multi-cursor `ctrl+d` is gone, and
  `ctrl+shift+l`, its other multi-cursor binding, holds the console.log
  snippet. Revisit only if multi-cursor is missed.
- `vscodevim.vim` and `asvetliakov.vscode-neovim` are both installed but
  neither is configured — nothing is shared with the nvim setup
