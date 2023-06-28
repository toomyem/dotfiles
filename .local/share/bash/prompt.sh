
declare -A fg
fg[black]="\e[0;0m"
fg[red]="\e[0;31m"
fg[green]="\e[0;32m"
fg[yellow]="\e[0;33m"
fg[blue]="\e[0;34m"
fg[magenta]="\e[0;35m"
fg[cyan]="\e[0;36m"
fg[while]="\e[0;37m"
fg[reset]="\e[m"

declare -A fg_bold
fg_bold[black]="\e[1;0m"
fg_bold[red]="\e[1;31m"
fg_bold[green]="\e[1;32m"
fg_bold[yellow]="\e[1;33m"
fg_bold[blue]="\e[1;34m"
fg_bold[magenta]="\e[1;35m"
fg_bold[cyan]="\e[1;36m"
fg_bold[while]="\e[1;37m"

_git_branch() {
    g=$(git branch 2>/dev/null)
    [ -n "$g" ] && echo -e " ${fg[green]}[on  $g]${fg[reset]}"
}

PROMPT_COMMAND="_status=\$?"
PS1="\n${fg[yellow]}\w${fg[reset]}\$(_git_branch)\n(\$_status) > "

