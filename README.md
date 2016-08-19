# Install
```bash
git clone https://github.com/andremohrmann/dotfiles.git
mv dotfiles/.zsh ~/.zsh
mv dotfiles/.zshrc ~/.zshrc
git clone https://github.com/zsh-users/zsh-autosuggestions.git ~/.zsh/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/zsh-syntax-highlighting
mkdir ~/.zsh/cache/
touch ~/.zsh/cache/dirs
chsh -s $(which zsh)
```

Login again
