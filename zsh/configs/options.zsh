# Options documentation in the Zsh Manual
# http://zsh.sourceforge.net/Doc/Release/Options.html#Options

# 16.2.1 Changing Directories
setopt auto_cd                       #cd by typing directory name if it is not a command

# 16.2.2 Completion
setopt always_to_end                 #move cursor to end if word had one match
setopt auto_list                     #automatically list choices on ambiguous completion
setopt auto_menu                     #automatically use menu completion

# 16.2.3 Expansion and Globbing
unsetopt case_glob