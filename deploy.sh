#!/bin/sh
set -e

if [ "$1" = "--install" ]; then
  # identify package manager, upgrade and install OS specific packages
  if hash pacman 2>/dev/null; then
      # Arch linux
      pacman -S --noconfirm sudo || true
      sudo pacman -Syu
      sudo pacman -S --noconfirm base-devel zsh-completions
      # dual-booting
      #sudo pacman -S os-prober
      pacman_bin="pacman -S --noconfirm"
  elif hash yum 2>/dev/null; then
      yum -y install sudo || true
      sudo yum -y upgrade
      sudo yum -y groupinstall 'Development Tools'
      sudo yum -y install util-linux-user
      pacman_bin="yum -y install"
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
  sudo $pacman_bin git neovim zsh tmux htop zip unzip mc xsel curl
fi

# get submodules
git submodule init
git submodule update --recursive --remote

# copy neovim colorscheme and config
mkdir -vp ~/.config/nvim/colors
ln -srfv base16-vim/colors/*.vim ~/.config/nvim/colors/
ln -srfv _vimrc ~/.config/nvim/init.vim

# copy vim colorscheme and config
mkdir -vp ~/.vim/colors
ln -srfv base16-vim/colors/*.vim ~/.vim/colors/
ln -srfv _vimrc ~/.vimrc

# copy ideavim config
ln -srfv _vimrc ~/.ideavimrc

# install oh-my-zsh
ln -srfTv oh-my-zsh ~/.oh-my-zsh

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

# copy binaries
mkdir -vp ~/bin
ln -srfv bin/* ~/bin/
