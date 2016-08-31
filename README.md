# Install

```bash
apt-get install -y zsh
git clone https://github.com/andremohrmann/dotfiles.git ~/dotfiles/
mkdir ~/.zsh/
ln -s ~/dotfiles/.zsh/zshrc.d ~/.zsh/zshrc.d
ln -s ~/dotfiles/.zshrc ~/.zshrc
git clone https://github.com/zsh-users/zsh-autosuggestions.git ~/.zsh/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/zsh-syntax-highlighting
mkdir ~/.zsh/cache/
touch ~/.zsh/cache/dirs
chsh -s $(which zsh)
(crontab -l ; echo "0 4 * * * sh ~/dotfiles/.zsh/update.sh") | crontab -
```

Login again

# Update

Run this as a script via crontab - e.g.

`0 4 * * * sh ~/dotfiles/.zsh/update.sh`

```bash
cd ~/dotfiles/
git pull -q origin master
cd ~/.zsh/zsh-autosuggestions
git pull -q origin master
cd ~/.zsh/zsh-syntax-highlighting
git pull -q origin master
```

Login again

`source ~/.zshrc` does not work at the moment due to a bug in _zsh_highlight_widget
