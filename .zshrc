# Set prompt
autoload -U promptinit; promptinit
export PROMPT='%{%F{cyan}%}[%2c% ]%F{red}$ %f'

# Load completions
autoload -Uz compinit
typeset -i updated_at=$(date +'%j' -r ~/.zcompdump 2>/dev/null || stat -f '%Sm' -t '%j' ~/.zcompdump 2>/dev/null)
if [ $(date +'%j') != $updated_at ]; then
  compinit -i
else
  compinit -C -i
fi

zmodload -i zsh/complist
_comp_options+=(globdots) # With hidden files
source $HOME/.dotfiles/zsh/completion.zsh

export PATH=$PATH:$HOME/bin

source $HOME/.dotfiles/zsh/configs/history.zsh

# Init nodenv
export PATH="$HOME/.nodenv/bin:$PATH"
type nodenv &>/dev/null && eval "$(nodenv init -)"

# Load Apple's Terminal additions... (Catalina and above)
# Supports stuff like opening new tabs in the last selected directory
[ -r "/etc/zshrc_$TERM_PROGRAM" ] && . "/etc/zshrc_$TERM_PROGRAM"

source $HOME/.dotfiles/zsh/configs/options.zsh

# Improve autocompletion style
zstyle ':completion:*' menu select   # select completions with arrow keys
zstyle ':completion:*' group-name '' # group results by category
zstyle ':completion:::::' completer _expand _complete _ignored _approximate # enable approximate matches for completion

# Fix delete key binding
bindkey '^[[3~' delete-char
bindkey '^[3;5~' delete-char

# Add Visual Studio Code cli (code) to $PATH
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

# Add Python to $PATH
export PATH="$PATH:$HOME/Library/Python/2.7/bin"

# Make sure Composer is in $PATH
export PATH="$PATH:$HOME/.composer/vendor/bin"

# Use GNU Sed by default
PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"

# Add z
. $(brew --prefix)/etc/profile.d/z.sh

# Aliases
if [ -f $HOME/.aliases ]; then
	source $HOME/.aliases
fi

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# Syntax highlighting
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Reliable Penguin stack map
function pmap {
  if [ -z $1 ]; then
    echo "please provide a URL/partial URL"
    return
  fi
  ssh jenkins "cat /jd/configs/penguin.map" | grep $1
}


