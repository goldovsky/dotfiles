# work aliases
if [ -f ~/.bashrc_work ]; then
    . ~/.bashrc_work
fi

# load up personal bash
if [ -f ~/.config/shell/bash/bashrc ]; then
    . ~/.config/shell/bash/bashrc
fi

# Force Electron apps (VS Code) to X11: native Wayland breaks keyboard layouts (Ctrl+Z resolved as Ctrl+W)
export ELECTRON_OZONE_PLATFORM_HINT=x11
