#!/bin/sh
set -e

if [ "$1" = "--install" ]; then
  # identify package manager, upgrade and install OS specific packages
  if hash pacman 2>/dev/null; then
      # Arch linux
      pacman -S --noconfirm --needed sudo || true
      sudo pacman -Syu
      sudo pacman -S --noconfirm --needed base-devel zsh-completions
      # dual-booting
      #sudo pacman -S os-prober
      pacman_bin="pacman -S --noconfirm --needed"
  elif hash dnf 2>/dev/null; then
      dnf -y install sudo || true
      sudo dnf -y upgrade
      sudo dnf -y group install 'Development Tools'
      sudo dnf -y install util-linux-user
      pacman_bin="dnf -y install"
  elif hash apt-get 2>/dev/null; then
      apt-get -y update || true
      apt-get -y install sudo || true
      sudo apt-get -y update
      sudo apt-get -y upgrade
      sudo apt-get -y install build-essential libpam-systemd
      pacman_bin="apt-get -y install"
  else
      pacman_bin=/bin/false
  fi

  # install basic packages
  sudo $pacman_bin git neovim zsh tmux htop zip unzip mc xsel curl trash-cli
fi

# get submodules
git submodule init
git submodule update --recursive --remote

# copy neovim config
mkdir -vp ~/.config/nvim
ln -srfv _vimrc ~/.config/nvim/init.vim

# install vim-plug to neovim
curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# copy vim config
ln -srfv _vimrc ~/.vimrc

# install vim-plug to vim
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# copy YouCompleteMe extra configuration
ln -srfv _ycm_extra_conf.py ~/.ycm_extra_conf.py

# copy ideavim config
ln -srfv _vimrc ~/.ideavimrc

# install oh-my-zsh
ln -srfTv oh-my-zsh ~/.oh-my-zsh
# install oh-my-zsh custom folder
ln -srfTv oh-my-zsh-custom ~/.oh-my-zsh-custom

# set zsh as the default shell
current_shell=$(expr "${SHELL:=/bin/false}" : '.*/\(.*\)')
if [ "$current_shell" != "zsh" ]; then
  zsh_shell="$(grep /zsh$ /etc/shells | tail -1)"
  echo "Changing default shell to ${zsh_shell}"
  chsh -s "${zsh_shell}"
fi

# copy zsh config
ln -srfv _zshrc ~/.zshrc
ln -srfv _zprofile ~/.zprofile

# copy tmux config
ln -srfv _tmux.conf ~/.tmux.conf

# copy clang-format
ln -srfv _clang-format ~/.clang-format

# copy pam environment
ln -srfv _pam_environment ~/.pam_environment

# copy binaries
mkdir -vp ~/bin
ln -srfv bin/* ~/bin/

# copy ssh-key agent
mkdir -p ~/.config/systemd/user
ln -srfv systemd-templates/ssh-agent.service ~/.config/systemd/user
systemctl --user enable ssh-agent.service
systemctl --user start ssh-agent.service
