#!/bin/bash
# Run this script as a cron - e.g. "0 4 * * * sh ~/dotfiles/.zsh/update.sh"

cd ~/dotfiles/
git pull -q origin master
cd ~/.zsh/zsh-autosuggestions
git pull -q origin master
cd ~/.zsh/zsh-syntax-highlighting
git pull -q origin master
