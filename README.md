# Install

```bash
apt-get install -y zsh
git clone https://github.com/andremohrmann/dotfiles.git ~/dotfiles/
cp -ar ~/dotfiles/.zsh ~/.zsh
cp -ar ~/dotfiles/.zshrc ~/.zshrc
git clone https://github.com/zsh-users/zsh-autosuggestions.git ~/.zsh/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/zsh-syntax-highlighting
mkdir ~/.zsh/cache/
touch ~/.zsh/cache/dirs
chsh -s $(which zsh)
```

Login again

# Update

```bash
cd ~/dotfiles/
git pull -q origin master
# Bypass the "cp -i" alias via "\"
\cp -ar --force ~/dotfiles/.zsh/ ~/
\cp -ar --force ~/dotfiles/.zshrc ~/.zshrc
cd ~/.zsh/zsh-autosuggestions
git pull -q origin master
cd ~/.zsh/zsh-syntax-highlighting
git pull -q origin master
```

Login again

`source ~/.zsh` does not work at the moment due to a bug in _zsh_highlight_widget
