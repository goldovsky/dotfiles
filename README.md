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