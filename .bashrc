# .bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='exa --icons -g'
alias ll='ls -l'
alias hc='herbstclient'
alias cfg='git --work-tree=$HOME --git-dir=$HOME/.cfg'

source /usr/share/bash-completion/completions/herbstclient
source $HOME/.local/share/bash/prompt.sh

neofetch
