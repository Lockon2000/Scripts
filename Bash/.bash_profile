# Enable tab completion
source ~/bash-scripts/git-completion.bash

# Adds git prompt functionality
source ~/bash-scripts/git-prompt.sh

# colors
red="\e[0;1;31m"
orange="\e[0;38;5;172m"
yellow="\e[0;1;33m"
green="\e[0;1;32m"
cyan="\e[0;1;36m"
white="\e[0;97m"
reset="\e[0m"

export GIT_PS1_SHOWDIRTYSTATE=1

# reset the colors after my command
trap 'echo -n -e "$reset"' DEBUG

# '\u' adds the name of the current user to the prompt
# '\H' adds the full hostname to the prompt
# '\$(__git_ps1)' git status prompt (generates a space before it even if empty)
# '\w' adds the name of the current directory
export PS1="\[$red\]\u\[$orange\]@\[$yellow\]\H \[$green\]\w \[$cyan\]\$(__git_ps1)
\[$white\]$ "

alias l="ls -la"