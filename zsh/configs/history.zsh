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