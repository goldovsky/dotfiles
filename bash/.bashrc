# work aliases
if [ -f ~/.config/bash/.bashrc_work ]; then
    . ~/.config/bash/.bashrc_work
fi

# load up personal bash
if [ -f ~/.config/bash/.bashrc ]; then
    . ~/.config/bash/.bashrc
fi
export PATH=$HOME/.local/bin:$PATH

# opencode
export PATH=/home/fvlb5625/.opencode/bin:$PATH

# figlet -f pagga "GOLD" > /tmp/gold.tmp && figlet -f pagga "OV" > /tmp/ov.tmp && figlet -f pagga "SKY" > /tmp/sky.tmp && while read -r l1 && read -r l2 <&3 && read -r l3 <&4; do printf "\033[33m%s\033[0m \031%s\033[0m \033[34m%s\033[0m\n" "$l1" "$l2" "$l3"; done < /tmp/gold.tmp 3< /tmp/ov.tmp 4< /tmp/sky.tmp
# echo -e "\033[33m░█▀▀░█▀█░█░░░█▀▄\033[37m░█▀█░█░█\033[34m░█▀▀░█░█░█░█\033[0m
# \033[33m░█░█░█░█░█░░░█░█\033[37m░█░█░▀▄▀\033[34m░▀▀█░█▀▄░░█░\033[0m
# \033[33m░▀▀▀░▀▀▀░▀▀▀░▀▀░\033[37m░▀▀▀░░▀░\033[34m░▀▀▀░▀░▀░░▀░\033[0m"
