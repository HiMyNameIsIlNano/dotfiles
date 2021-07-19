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

sudo pacman-mirrors --fasttrack 
sudo pacman -Syyu

yay -Syu zip \ 
	unzip \
	slack-desktop \
	autorandr \
	icaclient \
	bash-pureline-git \
	spotify \
	intellij-idea-ultimate-edition

curl -s "https://get.sdkman.io" | bash

yay -R palemoon 

mkdir -p ~/Development
cd ~/Development 

git clone git@github.com:HiMyNameIsIlNano/dotfiles.git

backup_file ~/.bashrc
backup_file ~/.profile
cd ~
ln ~/Development/dotfiles/.bashrc .bashrc
ln ~/Development/dotfiles/.profile .profile
ln ~/Development/dotfiles/.my_alias .my_alias

backup_file ~/.config/mimeapps.list
cd ~/.config/
ln ~/Development/dotfiles/mimeapps.list .profile

backup_file ~/.i3/config
cd ~/.i3
ln ~/Development/dotfiles/i3/config config

mkdir -p ~/.local/scripts
cd ~/.local/scripts
ln -s ~/Development/dotfiles/scripts i3-scripts

cd /usr/bin
sudo ln -s ~/Devlopment/dotfiles/scripts/toggle-select-monitor toggle-select-monitor
sudo ln -s ~/Devlopment/dotfiles/scripts/i3-resize i3-resize
sudo ln -s ~/Devlopment/dotfiles/scripts/i3-increase-font i3-increase-font

