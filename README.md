# dotfiles

We synchronise the config living in this folder with the one on the current system using gnu stow.

```BASH
# from this directory
stow -t ~ */

# if file already exist 
stow -t ~ --override=force */

# or move the existing file into this repo // this one is the one I end up using
stow -t ~ --adopt */
```

## VS Code
For now, I don't link the files with stow.

## List of software
- git
- lazygit
- gnu stow (sync config file to a git repo)
- alacritty
- starship
- tmux (or Zellij?)
- fzf
- neovim (lazyvim or nvchad?)
- bat (/batcat, cat with highlighting)
- anicli
- youtube-dl

### software to check
- atuin (better search ctrl+r)
- tdlr (line man but shorter)
- eza or zoxine? (like ls)
- rofi (or any app launcher)
- jq (manipulate json query in shell)
- broot (https://github.com/Canop/broot)
- yt-dlp (https://github.com/yt-dlp/yt-dlp)

## Scripts to do
- cdp (from each .git fetch directories)

## General designs
Catpuccin Mocha | Iosevka Nerd Font
Ayu Mirage | ZedMono Nerd Font
