# .bash_profile

[ -z "$SSH_AGENT_PID" ] && eval `ssh-agent`

# Get the aliases and functions
[ -f $HOME/.bashrc ] && . $HOME/.bashrc

export PATH=$HOME/.local/bin:$PATH

export XDG_RUNTIME_DIR=/tmp/xdg-$USER
mkdir -p $XDG_RUNTIME_DIR
chmod 700 $XDG_RUNTIME_DIR
export XDG_DATA_DIRS=$HOME/.local/share/flatpak/exports/share:$XDG_DATA_DIRS

