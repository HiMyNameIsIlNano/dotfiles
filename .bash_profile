#
# ~/.bash_profile
#

eval $(gnome-keyring-daemon --start)
export SSH_AUTH_SOCK

[[ -f ~/.bashrc ]] && . ~/.bashrc
