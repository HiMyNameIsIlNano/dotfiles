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

init_i3_keyboard_layout() {
    cd $DEV_FOLDER/
    git clone https://github.com/porras/i3-keyboard-layout.git
    sudo cp ./i3-keyboard-layout/i3-keyboard-layout /usr/bin
    chmod +x /usr/bin/i3-keyboard-layout
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
	intellij-idea-ultimate-edition \
	intellij-idea-ultimate-edition-jre \
    docker \
    docker-compose \
	nerd-fonts-fira-code \
    keepassxc \
    timeshift \
    nodejs \
    npm \
    pulseaudio \
    webex-bin

# Required by Webex: Enable network access to local sound devices
sudo usermod -aG audio $(whoami)
pulseaudio --start
pacmd load-module module-native-protocol-tcp

yay -Rs palemoon-bin mousepad

# Configure docker
sudm systemctl start docker.service
sudo systemctl enable docker.service
sudo usermod -aG docker $(whoami)

export DEV_FOLDER=~/Development

mkdir -p $DEV_FOLDER
cd $DEV_FOLDER 

git clone git@github.com:HiMyNameIsIlNano/dotfiles.git

backup_file ~/.bashrc
backup_file ~/.profile
backup_file ~/.my_alias
backup_file ~/.bash_profile
cd ~
ln -s $DEV_FOLDER/dotfiles/.bashrc .bashrc
ln -s $DEV_FOLDER/dotfiles/.profile .profile
ln -s $DEV_FOLDER/dotfiles/.my_exports .my_exports
ln -s $DEV_FOLDER/dotfiles/.my_plugins .my_plugins
ln -s $DEV_FOLDER/dotfiles/.my_alias .my_alias
ln -s $DEV_FOLDER/dotfiles/.bash_profile .bash_profile
ln -s /usr/share/pureline pureline
ln -s $DEV_FOLDER/dotfiles/tty_full.conf .pureline.conf
ln -s $DEV_FOLDER/dotfiles/.vimrc .vimrc

backup_file ~/.config/mimeapps.list
cd ~/.config/
ln -s $DEV_FOLDER/dotfiles/mimeapps.list mimeapps.list

backup_file ~/.i3/config
cd ~/.i3
ln -s $DEV_FOLDER/dotfiles/i3/config i3.config

mkdir -p ~/.local/scripts
cd ~/.local/scripts
ln -s $DEV_FOLDER/dotfiles/scripts i3-scripts
ln -s $DEV_FOLDER/dotfiles/start-my-conky start-my-conky

cd /usr/bin
sudo ln -s $DEV_FOLDER/dotfiles/scripts/toggle-select-monitor toggle-select-monitor
sudo ln -s $DEV_FOLDER/dotfiles/scripts/i3-resize i3-resize
sudo ln -s $DEV_FOLDER/dotfiles/scripts/i3-increase-font i3-increase-font
sudo ln -s $DEV_FOLDER/dotfiles/start-my-conky start-my-conky
sudo ln -s $DEV_FOLDER/dotfiles/scripts/try-use-external-monitor try-use-external-monitor

cd /usr/share/conky
sudo ln -s $DEV_FOLDER/dotfiles/my_conky_shortcuts my_conky_shortcuts
sudo ln -s $DEV_FOLDER/dotfiles/my_conky my_conky

init_ssh_agent
init_i3_keyboard_layout
install_sdkman
