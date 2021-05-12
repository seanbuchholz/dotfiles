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
source $HOME/.config/completion.zsh

export PATH=$PATH:$HOME/bin

# Set history settings -- stolen wholesale from oh-my-zsh because it's good and the built-ins are not
function omz_history {
	local clear list
	zparseopts -E c=clear l=list

	if [[ -n "$clear" ]]; then
		# if -c provided, clobber the history file
		echo -n >| "$HISTFILE"
		echo >&2 History file deleted. Reload the session to see its effects.
	elif [[ -n "$list" ]]; then
		# if -l provided, run as if calling `fc' directly
		builtin fc "$@"
	else
		# unless a number is provided, show all history events (starting from 1)
		[[ ${@[-1]-} = *[0-9]* ]] && builtin fc -l "$@" || builtin fc -l "$@" 1
	fi
}

# Timestamp format
case ${HIST_STAMPS-} in
	"mm/dd/yyyy") alias history='omz_history -f' ;;
	"dd.mm.yyyy") alias history='omz_history -E' ;;
	"yyyy-mm-dd") alias history='omz_history -i' ;;
	"") alias history='omz_history' ;;
	*) alias history="omz_history -t '$HIST_STAMPS'" ;;
esac

## History file configuration
[ -z "$HISTFILE" ] && HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000

## History command configuration
setopt extended_history       # record timestamp of command in HISTFILE
setopt hist_find_no_dups      # skip duplicates and show each command only once while stepping
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_all_dups   # do not write duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
setopt hist_reduce_blanks     # remove superfluous blanks from history items
setopt inc_append_history     # add commands to HISTFILE in order of execution
setopt share_history          # share command history data

# Better up arrow / down arrow history behaviour
zmodload zsh/zle
autoload -Uz +X add-zle-hook-widget

autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "$terminfo[kcuu1]" up-line-or-beginning-search   # Up
bindkey "$terminfo[kcud1]" down-line-or-beginning-search # Down

# Make sure that the terminal is in application mode when zle is active, since
# only then values from $terminfo are valid
if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
	function zle-line-init() {
		echoti smkx
	}
 	function zle-line-finish() {
		echoti rmkx
	}
	zle -N zle-line-init
	zle -N zle-line-finish
fi

# Init nodenv
export PATH="$HOME/.nodenv/bin:$PATH"
type nodenv &>/dev/null && eval "$(nodenv init -)"

# Load Apple's Terminal additions... (Catalina and above)
# Supports stuff like opening new tabs in the last selected directory
[ -r "/etc/zshrc_$TERM_PROGRAM" ] && . "/etc/zshrc_$TERM_PROGRAM"

# Set up some sensible options
setopt auto_cd                       #cd by typing directory name if it is not a command
# setopt correct_all                   #autocorrect commands
setopt auto_list                     #automatically list choices on ambiguous completion
setopt auto_menu                     #automatically use menu completion
setopt always_to_end                 #move cursor to end if word had one match

# Improve autocompletion style
zstyle ':completion:*' menu select   # select completions with arrow keys
zstyle ':completion:*' group-name '' # group results by category
zstyle ':completion:::::' completer _expand _complete _ignored _approximate # enable approximate matches for completion

# Fix delete key binding
bindkey '^[[3~' delete-char
bindkey '^[3;5~' delete-char

# Enable auto-completions for Homeshick
source "$HOME/.homesick/repos/homeshick/homeshick.sh"
fpath=($HOME/.homesick/repos/homeshick/completions $fpath)

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

# Refresh dotfiles on shell startup
homeshick --quiet refresh

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# Syntax highlighting
source $HOME/.oh-my-zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Reliable Penguin stack map
function pmap {
  if [ -z $1]; then
    echo "please provide a URL/partial URL"
    return
  fi
  ssh jenkins "cat /jd/configs/penguin.map" | grep $1
}


