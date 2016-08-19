#!/bin/bash
# Run this script as a cron - e.g. "0 4 * * * ~/dotfiles/.zsh/zshrc.d/update.sh"

cd ~/dotfiles/
git pull -q origin master
# Bypass the "cp -i" alias via "\"
\cp -ar --force ~/dotfiles/.zsh/ ~/
\cp -ar --force ~/dotfiles/.zshrc ~/.zshrc
cd ~/.zsh/zsh-autosuggestions
git pull -q origin master
cd ~/.zsh/zsh-syntax-highlighting
git pull -q origin master
