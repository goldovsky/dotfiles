# dotfiles

We synchronise the config living in this folder with the one on the current system using gnu stow.

```BASH
# from this directory
stow -t ~ */

# if file already exist 
# stow -t ~ --override=force */

# or move the existing file into this repo // this one is the one I end up using
# stow -t ~ --adopt */
```

## VS Code
For now, I don't link the files with stow.

## List of software
- git
- gnu stow (sync config file to a git repo)
- alacritty
- starship
- tmux (or Zellij?)
- neovim (lazyvim or nvchad?)
- bat (/batcat, better cat)
- anicli

### software to check
- atuin (better search ctrl+r)
- tdlr (line man but shorter)
- eza or zoxine? (like ls)
- rofi (or any app launcher)