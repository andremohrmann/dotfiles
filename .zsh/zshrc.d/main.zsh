# Terminal background
# RGB: 0,43,54 OR 7,54,66
# PuTTYtray settings
# PuTTYtray configfile: puttytray_Default%20Settings.txt
# PuTTY colors: https://github.com/andremohrmann/solarized

autoload -Uz compinit promptinit colors && colors
compinit
promptinit

# More colors
export TERM="xterm-256color"

# Set prompt theme
#prompt suse

###############
### History ###
###############

if [ -z "$HISTFILE" ]; then
  HISTFILE=$HOME/.zsh/.zsh_history
fi

HISTSIZE=10000
SAVEHIST=10000
HISTSTAMPS="yyyy-mm-dd"

# Show history
case $HISTSTAMPS in
  "mm/dd/yyyy") alias history='fc -fl 1' ;;
  "dd.mm.yyyy") alias history='fc -El 1' ;;
  "yyyy-mm-dd") alias history='fc -il 1' ;;
  *) alias history='fc -l 1' ;;
esac

setopt append_history
setopt extended_history
setopt hist_expire_dups_first
#setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_verify
setopt inc_append_history
#setopt share_history

##################
### Keybinding ###
##################

# Make Insert, Del, Pos1, End work
bindkey "^[[2~" yank                # Insert
bindkey "^[[3~" delete-char         # Del
bindkey "^[[1~" beginning-of-line   # Pos1
bindkey "^[[4~" end-of-line         # End

# Make numpad work
bindkey -s "^[Op" "0"     # 0
bindkey -s "^[On" ","     # ,
bindkey -s "^[OM" "^M"    # Enter
bindkey -s "^[Oq" "1"     # 1
bindkey -s "^[Or" "2"     # 2
bindkey -s "^[Os" "3"     # 3
bindkey -s "^[Ot" "4"     # 4
bindkey -s "^[Ou" "5"     # 5
bindkey -s "^[Ov" "6"     # 6
bindkey -s "^[Ow" "7"     # 7
bindkey -s "^[Ox" "8"     # 8
bindkey -s "^[Oy" "9"     # 9
bindkey -s "^[Ol" "+"     # +
bindkey -s "^[OS" "-"     # -
bindkey -s "^[OR" "*"     # *
bindkey -s "^[OQ" "/"     # /

# Use up and down arrow to search history
bindkey "^[OA" up-line-or-history   # Up arrow
bindkey "^[OB" down-line-or-history   # Down arrow

# history expansion with space
bindkey " " magic-space   #!command[SPACE]

# Use PageUp and PageDown to search the history for commands that start with what has already been typed
bindkey '^[[5~' history-beginning-search-backward   # PageUp
bindkey '^[[6~' history-beginning-search-forward    # Page Down

# "Alt + s" inserts "sudo " at the beginning of the line
function prepend-sudo {
  if [[ $BUFFER != "sudo "* ]]; then
    BUFFER="sudo $BUFFER"; CURSOR+=5
  fi
}
zle -N prepend-sudo
bindkey "^[s" prepend-sudo # Alt + s

###############
### Aliases ###
###############

# List stuff
export LS_OPTIONS='--color=auto'
eval "`dircolors`"
alias ls='ls $LS_OPTIONS'
alias ll='ls $LS_OPTIONS -l'
alias l='ls $LS_OPTIONS -lAhF'
alias tree='find . -print | sed -e "s;[^/]*/;|____;g;s;____|; |;g"'
alias inodes='find / -xdev -printf '%h\n' | sort | uniq -c | sort -k 1 -n'

# Easy chmod
alias 000='chmod 000'
alias 644='chmod 644'
alias 664='chmod 664'
alias 755='chmod 755'
alias 775='chmod 775'
alias xx='chmod +x'

# Recursively find all files/directories in current directory and chmod them
alias findf='find . -type f -exec chmod 664 {} \;'
alias findd='find . -type d -exec chmod 775 {} \;'

# grep beautification
alias grep='grep --color=auto'

# Navigation aliases
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias cd..='cd ..'

# Shell conveniences
alias sz='source ~/.zshrc'

# copy with a progress bar.
alias cpv="rsync -poghb --backup-dir=/tmp/rsync -e /dev/null --progress --"

# Get directory size
alias ds='du -h --max-depth=0 $1' # requires one input

# Get directory size of every item in current directory
alias dsd='du -h --max-depth=0 *'

# Get sizes of everything in current directory and show total, sort by size
alias ducks='du -cksh * | sort -h'

# Commonly used commands
alias psa="ps aux"
alias psag="ps aux | grep "
alias t='tail -f -n 2000'
alias ml='tail -f /var/log/mail.log -n 2000'
alias mlg='cat /var/log/mail.log | grep $1'
alias al='tail -f /var/log/auth.log -n 2000'
alias alg='cat /var/log/auth.log | grep $1'
alias h='history'
alias hg='history | grep'
alias mkdir='mkdir -p'

# docker related
if which docker >/dev/null; then
alias dps="docker ps"
alias dpsa="docker ps --no-trunc"
alias dtop="watch -n 1 docker ps"
alias dtopa="watch -n 1 docker ps --no-trunc"
alias dpstop="watch -n 1 docker ps"
alias dpstop="watch -n 1 docker ps --no-trunc"
alias dpsg="docker ps --no-trunc| grep "
function dsa(){ docker stop $(docker ps -a -q); }
function de(){ docker exec -it "$1" "$2"; }
function deb(){ docker exec -it "$1" bash; }
function dem(){ docker exec -it "$1" mysql -p; }
function drm(){ docker rm $(docker ps -a -q) }
fi

# git related

# Some more aliases to avoid making mistakes
alias rm='rm -iv'
alias cp='cp -iv'
alias mv='mv -iv'

# Add colors to output
alias c='colorize_via_pygmentize'

# Resume wget by default
alias wget='wget -c'

# Misc
alias :q='quit'
alias sudo='sudo '
#alias server='service'

# Mitigate typos
alias catr='cat'

# 4 teh lulz
alias fuck='sudo $(fc -ln -1)'
alias fucking='sudo '
alias please='sudo '
alias weather='curl -4 http://wttr.in/Bielefeld'

# Ubuntu on Windows 10 (Windows Subsystem for Linux) specific
afk='/mnt/c/Windows/System32/rundll32.exe user32.dll,LockWorkStation'    # If executing .exe files will ever work in WSL, this will lock the screen

#################
### Functions ###
#################

# List directory after changeing into it
function lcd {
  cd "$@" && l
}

# Make directory and cd into in
mcd()
{
  test -d "$1" || mkdir -p "$1" && cd "$1"
}

# Move up multiple directories
function up {
  ups=""
  for i in $(seq 1 $1); do
    ups=$ups"../"
  done
  cd $ups
}

# Make backups
bu() {
  if [[ -d $@ ]]; then
    tar czf "$@"_bu-`date +%Y%m%d-%H%M`.tar.gz "$@"; echo "`date +%Y-%m-%d_%H:%M` backed up $PWD/$@" >> ~/.backups.log;
  elif [[ -f $@ ]]; then
    cp "$@" "$@".bu-`date +%Y%m%d-%H%M`; echo "`date +%Y-%m-%d_%H:%M` backed up $PWD/$@" >> ~/.backups.log;
  else
    echo "$@ is not valid"
    exit 1
  fi
}

# Show local IP
#if ( expr $VER_ID \<= 9 >/dev/null ); then # Check if version is older than stretch
#if [ $(dpkg-query -W -f='${Status}' ifconfig 2>/dev/null | grep -c "ok installed") -eq 0 ]; then # check if package ifconfig is installed
if [ -x "$( command -v ifconfig )" ]; then # Check if command ifconfig is available
  ipl() {
    ifconfig -a | perl -nle'/(\d+\.\d+\.\d+\.\d+)/ && print $1' | sed 's/127.0.0.1//g' | sed ':a;N;$!ba;s/\n/ /g'
  }
else
  ipl() {
    command ip addr | grep "inet\b" | awk '{print $2}' | cut -d/ -f1 | sed 's/127.0.0.1//g' | sed ':a;N;$!ba;s/\n/ /g'
  }
fi

# Show public IP
ipp() {
  dig +short myip.opendns.com @resolver1.opendns.com
}

# Colorized manuals
man() {
  env \
    LESS_TERMCAP_mb=$(printf "\e[1;31m") \
    LESS_TERMCAP_md=$(printf "\e[1;31m") \
    LESS_TERMCAP_me=$(printf "\e[0m") \
    LESS_TERMCAP_se=$(printf "\e[0m") \
    LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
    LESS_TERMCAP_ue=$(printf "\e[0m") \
    LESS_TERMCAP_us=$(printf "\e[1;32m") \
    man "$@"
}

colorize_via_pygmentize() {
  if [ ! -x "$(which pygmentize)" ]; then
    echo "package \'pygmentize\' is not installed!"
    return -1
  fi

  if [ $# -eq 0 ]; then
    pygmentize -g $@
  fi

  for FNAME in $@; do
      filename=$(basename "$FNAME")
      lexer=`pygmentize -N \"$filename\"`
      if [ "Z$lexer" != "Ztext" ]; then
        pygmentize -l $lexer "$FNAME"
      else
        pygmentize -g "$FNAME"
      fi
  done
}

##################
### Navigation ###
##################

# Remember recent directories and change to them with cd -<NUM>
DIRSTACKFILE="$HOME/.zsh/cache/dirs"
if [[ -f $DIRSTACKFILE ]] && [[ $#dirstack -eq 0 ]]; then
  dirstack=( ${(f)"$(< $DIRSTACKFILE)"} )
#  [[ -d $dirstack[1] ]] && cd $dirstack[1]    # Return to last directory after reconnect
fi
chpwd() {
  print -l $PWD ${(u)dirstack} >$DIRSTACKFILE
}

DIRSTACKSIZE=100

setopt AUTO_PUSHD PUSHD_SILENT PUSHD_TO_HOME

setopt PUSHD_MINUS # Reverse +/- operators for dirstack

# Type 'dir' instead of 'cd dir'
setopt AUTO_CD

# Make file name completion case-insensitive
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'

####################
### Welcome user ###
####################

# Print date, time and uptime
echo -e "\nHello $USER! Today is $fg[cyan]$(date)$reset_color Week: $fg[cyan]$(date +%V)$reset_color"
echo -ne "Uptime for this system is $fg[cyan]";uptime | awk '{print $3,$4,$5}' | sed s/.$/\ hours/    # Ulgy as fuck sed, also not working properly if uptime is < 1 day
echo -ne "$reset_color\n"

# Get OS
#OS=$(cat /etc/*-release | sed -n 5,5p | sed 's/ID=//g')
#OS=$(cat /etc/*-release | sed -n 's/.*\(PRETTY_NAME\=.*\).*/\1/p' | sed 's/PRETTY_NAME=//g' | awk '{print $1}' | sed 's/^.//')

OS=""
VER=""
VER_ID=""

if [ -f /etc/os-release ]; then
  # freedesktop.org and systemd
  . /etc/os-release
  OS=$NAME
  VER=$VERSION
  VER_ID=$VERSION_ID
  # Debian specific stuff
  if [ "$OS" = "Debian GNU/Linux" ]; then
    OS=$(echo $OS | awk '{print $1}')
    read _ VER <<< "$VERSION"
    VER=$(echo $VER | sed 's/^.\(.*\).$/\1/')
  fi
elif type lsb_release >/dev/null 2>&1; then
  # linuxbase.org
  OS=$(lsb_release -si)
  VER=$(lsb_release -sc)
  VER_ID=$(lsb_release -sr)
elif [ -f /etc/lsb-release ]; then
  # For some versions of Debian/Ubuntu without lsb_release command
  . /etc/lsb-release
  OS=$DISTRIB_ID
  VER=$DISTRIB_CODENAME
  VER_ID=$DISTRIB_RELEASE
elif [ -f /etc/debian_version ]; then
  # Older Debian/Ubuntu/etc.
  OS=Debian
  VER_ID=$(cat /etc/debian_version)
else
  # Fall back to uname, e.g. "Linux <version>", also works for BSD, etc.
  OS=$(uname -s)
  VER=$(uname -r)
fi

# If OS is debian print full version, if not just print the OS
if [ $OS = "Debian" ]; then
  echo -ne "This system is running on $fg[cyan]$(cat /etc/*-release | sed -n 's/.*\(PRETTY_NAME\=.*\).*/\1/p' | sed 's/PRETTY_NAME=//g')$reset_color Version: $fg[cyan]";cat /etc/debian_version
  echo -ne "$reset_color\n"
else
  echo -ne "This system is running on $fg[cyan]$(cat /etc/*-release | sed -n 's/.*\(PRETTY_NAME\=.*\).*/\1/p' | sed 's/PRETTY_NAME=//g')"
  echo -ne "$reset_color\n"
fi

if [ $UID -eq 0 ]; then
  echo -ne "This system has the following public IP: "$fg[cyan]$(dig +short myip.opendns.com @resolver1.opendns.com)"$reset_color\n"
  echo -ne "This system has the following internal IP: "$fg[cyan]$(ipl)
  echo -e "$reset_color\n"
fi

############
### Misc ###
############

# Allow pipe to multiple outputs
setopt MULTIOS

# Spell check commands
setopt CORRECT
export SPROMPT="Correct $fg[red]%R$reset_color to $fg[green]%r?$reset_color (No, Yes, Abort, Edit) "

# Case insensitive globbing
setopt NO_CASE_GLOB

# Extended globbing
setopt EXTENDED_GLOB

# Turns on command substitution in the prompt (and parameter expansion and arithmetic expansion)
setopt PROMPT_SUBST

# Wait 10 seconds if you do something that will delete everything
setopt RM_STAR_WAIT

# Overwrite Ctrl-s
setopt NO_FLOW_CONTROL

### NO IDEA WHAT THIS ACTAULLYY DOES ###
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*' group-name ''

# If command not found, rehash available commands
_force_rehash() {
  (( CURRENT == 1 )) && rehash
  return 1
}
zstyle ':completion:*' completer _expand _force_rehash _complete _approximate _ignored

# Don't prompt for a huge list, page it
zstyle ':completion:*:default' list-prompt '%S%M matches%s'

# Don't prompt for a huge list, menu it
zstyle ':completion:*:default' menu 'select=0'

# Unset listing ambiguous comletions
unsetopt LIST_AMBIGUOUS

# Complete in middle of word
setopt  COMPLETE_IN_WORD




################################
### Needs testing/validation ###
################################

# color code completion!!!!  Wohoo!
#zstyle ':completion:*' list-colors "=(#b) #([0-9]#)*=36=31"



# set command completions
compctl -a {,un}alias
compctl -b bindkey
compctl -c command
compctl -/ {c,push,pop}d
compctl -E {print,set,unset}env
#compctl -c exec
compctl -f -x "c[-1,exec]" -c -- exec
compctl -j fg
# no -g according to zshcompctl
#compctl -g {ch}grp
compctl -j kill
compctl -c man
compctl -c nohup
compctl -u {ch}own
compctl -o {set,unset}opt
compctl -f -x "c[-1,sudo]" -c -- sudo
compctl -c {whence,where,which}
compctl -M '' 'm:{a-zA-Z}={A-Za-z}'



function most_useless_use_of_zsh {
  local lines columns colour a b p q i pnew
  ((columns=COLUMNS-1, lines=LINES-1, colour=0))
  for ((b=-1.5; b<=1.5; b+=3.0/lines)); do
    for ((a=-2.0; a<=1; a+=3.0/columns)); do
      for ((p=0.0, q=0.0, i=0; p*p+q*q < 4 && i < 32; i++)); do
        ((pnew=p*p-q*q+a, q=2*p*q+b, p=pnew))
      done
      ((colour=(i/4)%8))
      echo -n "\\e[4${colour}m "
    done
    echo
  done
}

# Random quote

WHO_COLOR="\e[0;33m"
TEXT_COLOR="\e[0;35m"
COLON_COLOR="\e[0;35m"
END_COLOR="\e[m"

if [[ -x `which curl` ]]; then
  function quote() {
    Q=$(curl -s --connect-timeout 2 "http://www.quotationspage.com/random.php3" | iconv -c -f ISO-8859-1 -t UTF-8 | grep -m 1 "dt ")
    TXT=$(echo "$Q" | sed -e 's/<\/dt>.*//g' -e 's/.*html//g' -e 's/^[^a-zA-Z]*//' -e 's/<\/a..*$//g')
    W=$(echo "$Q" | sed -e 's/.*\/quotes\///g' -e 's/<.*//g' -e 's/.*">//g')
    if [ "$W" -a "$TXT" ]; then
      echo "${WHO_COLOR}${W}${COLON_COLOR}: ${TEXT_COLOR}“${TXT}”${END_COLOR}"
    fi
  }

else
  echo "Quote function needs curl to work..." >&2
fi

function all_the_colors {
  for x in 0 1 4 5 7 8; do 
    for i in `seq 30 37`; do 
      for a in `seq 40 47`; do 
        echo -ne "\e[$x;$i;$a""m\\\e[$x;$i;$a""m\e[0;37;40m "; 
      done; echo; 
    done; 
  done; 
  echo "";
}

# Extract archives - use: extract <file>
function extract() {
  if [ -f "$1" ] ; then
    local filename=$(basename "$1")
    local foldername="${filename%%.*}"
    local fullpath=`perl -e 'use Cwd "abs_path";print abs_path(shift)' "$1"`
    local didfolderexist=false
    if [ -d "$foldername" ]; then
      didfolderexist=true
      read -p "$foldername already exists, do you want to overwrite it? (y/n) " -n 1
      echo
        if [[ $REPLY =~ ^[Nn]$ ]]; then
    return
  fi
    fi
    mkdir -p "$foldername" && cd "$foldername"
    case $1 in
      *.tar.bz2) tar xjf "$fullpath" ;;
      *.tar.gz) tar xzf "$fullpath" ;;
      *.tar.xz) tar Jxvf "$fullpath" ;;
      *.tar.Z) tar xzf "$fullpath" ;;
      *.tar) tar xf "$fullpath" ;;
      *.taz) tar xzf "$fullpath" ;;
      *.tb2) tar xjf "$fullpath" ;;
      *.tbz) tar xjf "$fullpath" ;;
      *.tbz2) tar xjf "$fullpath" ;;
      *.tgz) tar xzf "$fullpath" ;;
      *.txz) tar Jxvf "$fullpath" ;;
      *.zip) unzip "$fullpath" ;;
      *) echo "'$1' cannot be extracted via extract()" && cd .. && ! $didfolderexist && rm -r "$foldername" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}




# Use fish like autosuggestions from https://github.com/zsh-users/zsh-autosuggestions
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# Set color for autosuggestions to dark grey
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'

# Use syntax highlighting from https://github.com/zsh-users/zsh-syntax-highlighting/
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
