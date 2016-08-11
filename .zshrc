# .zshrc

# Load all files from zshrc.d directory
if [ -d $HOME/.zsh/zshrc.d ]; then
  for file in $HOME/.zsh/zshrc.d/*.zsh; do
    source $file
  done
fi
