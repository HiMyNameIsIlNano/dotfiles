#!/bin/bash

wait_for_seconds(){
  local seconds="$@"
  log_warn "waiting ${seconds} seconds before continuing..."
  sleep ${seconds}
}

log_info(){
  local text="$@"
  GREEN='\033[0;32m'
  WHITE='\033[0;37m'
  NC='\033[0m'
  printf "${GREEN}[INFO] ${WHITE}${text}${NC}\n"
}

log_warn(){
  local text="$@"
  YELLOW='\033[0;33m'
  WHITE='\033[0;37m'
  NC='\033[0m'
  printf "${YELLOW}[WARN] ${WHITE}${text}${NC}\n"
}

backup_file() {
  local file="$@"
  wait_for_seconds 5

  if [ -f "${file}" ]
  then
    log_info "Backing-up ${file}"
    mv ${file} ${file}.${timestamp}.bak
  else
    log_info "Nothing to backup. File ${file} does not exist"
  fi
}

init_ssh_agent() {
    mkdir -p ~/.ssh
    ~/.ssh/config <<-EOSSH
Host *
    AddKeysToAgent yes
    UseKeychain yes
    IdentityFile ~/.ssh/id_rsa
EOSSH
    sudo echo 'password	   optional	pam_gnome_keyring.so' >> /etc/pam.d/passwd
}

install_sdkman() {
    curl -s "https://get.sdkman.io" | bash
    source "~/.sdkman/bin/sdkman-init.sh"
}

sudo pacman-mirrors --fasttrack 
sudo pacman -Syyu

yay -Syu zip \ 
	unzip \
	git \
	slack-desktop \
	autorandr \
	icaclient \
	bash-pureline-git \
	spotify \
	libsecret \
	seahorse \
	intellij-idea-ultimate-edition

yay -Rs palemoon-bin mousepad

mkdir -p ~/Development
cd ~/Development 

git clone git@github.com:HiMyNameIsIlNano/dotfiles.git

backup_file ~/.bashrc
backup_file ~/.profile
backup_file ~/.my_alias
backup_file ~/.bash_profile
cd ~
ln -s ~/Development/dotfiles/.bashrc .bashrc
ln -s ~/Development/dotfiles/.profile .profile
ln -s ~/Development/dotfiles/.my_exports .my_exports
ln -s ~/Development/dotfiles/.my_plugins .my_plugins
ln -s ~/Development/dotfiles/.my_alias .my_alias
ln -s ~/Development/dotfiles/.bash_profile .bash_profile
ln -s /usr/share/pureline pureline
ln -s ~/Development/dotfiles/tty_full.conf .pureline.conf
ln -s ~/Development/dotfiles/.vimrc .vimrc

backup_file ~/.config/mimeapps.list
cd ~/.config/
ln -s ~/Development/dotfiles/mimeapps.list mimeapps.list

backup_file ~/.i3/config
cd ~/.i3
ln -s ~/Development/dotfiles/i3/config config

mkdir -p ~/.local/scripts
cd ~/.local/scripts
ln -s ~/Development/dotfiles/scripts i3-scripts
ln -s ~/Development/dotfiles/start_my_conky start_my_conky

cd /usr/bin
sudo ln -s ~/Devlopment/dotfiles/scripts/toggle-select-monitor toggle-select-monitor
sudo ln -s ~/Devlopment/dotfiles/scripts/i3-resize i3-resize
sudo ln -s ~/Devlopment/dotfiles/scripts/i3-increase-font i3-increase-font
sudo ln -s ~/Devlopment/dotfiles/scripts/start_my_conky start_my_conky

init_ssh_agent
install_sdkman