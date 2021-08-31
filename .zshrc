# Load configuration
source $ZCONF/prompt.zsh
source $ZCONF/colors.zsh # load color definitions for pretty output
source $ZCONF/options.zsh # load zsh options
source $ZCONF/history.zsh # load history (incl OMZ history dupe)
source $HOME/.aliases # load aliases
for function in $XDG_CONFIG_HOME/zsh/functions/*; do
  source $function
done

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
source $XDG_CONFIG_HOME/zsh/completion.zsh

pathadd $HOME/bin

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Init nodenv
pathadd $HOME/.nodenv/bin
type nodenv &>/dev/null && eval "$(nodenv init -)"

# Load Apple's Terminal additions... (Catalina and above)
# Supports stuff like opening new tabs in the last selected directory
[ -r "/etc/zshrc_$TERM_PROGRAM" ] && . "/etc/zshrc_$TERM_PROGRAM"

# Improve autocompletion style
zstyle ':completion:*' menu select   # select completions with arrow keys
zstyle ':completion:*' group-name '' # group results by category
zstyle ':completion:::::' completer _expand _complete _ignored _approximate # enable approximate matches for completion

# Fix delete key binding
bindkey '^[[3~' delete-char
bindkey '^[3;5~' delete-char

# Add Visual Studio Code cli (code) to $PATH
pathadd $HOME/Applications/Visual Studio Code.app/Contents/Resources/app/bin

# Add Python to $PATH
pathadd $HOME/Library/Python/2.7/bin

# Make sure Composer is in $PATH
pathadd $HOME/.composer/vendor/bin

# Use GNU Sed by default
pathadd /usr/local/opt/gnu-sed/libexec/gnubin

# Add z
. $(brew --prefix)/etc/profile.d/z.sh

# Syntax highlighting
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
