#!/bin/bash
set -e

# Install a package from Arch User Repository
# This function works even for root (as opposed to plain makepkg -si).
# Usage: aur_install PACKAGE_NAME
aur_install() (
  cd "/tmp/"
  sudo -u nobody git clone "https://aur.archlinux.org/$1.git" "/tmp/$1"
  cd "/tmp/$1"
  source PKGBUILD
  sudo pacman -S --noconfirm --needed --asdeps "${makedepends[@]}" "${depends[@]}"
  sudo -u nobody GOPATH="/tmp/.nobody_cache/.go" XDG_CACHE_HOME="/tmp/.nobody_cache" makepkg
  sudo pacman -U --noconfirm --needed "$1"-*.pkg.tar.*
  cd /tmp
  sudo rm -rf "/tmp/.nobody_cache" "/tmp/$1"
)

if [ "$1" = "--install" ]; then
  # identify package manager, upgrade and install OS specific packages
  if hash pacman 2>/dev/null; then
      # Arch linux
      pacman -Syu --noconfirm --needed sudo || true
      sudo pacman -Syu --noconfirm
      sudo pacman -S --noconfirm --needed base-devel zsh-completions git
      # Yay
      if ! hash yay 2>/dev/null; then aur_install yay-bin; fi
      # Direnv
      if ! hash direnv 2>/dev/null; then aur_install direnv; fi
      # dual-booting
      #sudo pacman -S os-prober
      pacman_bin="pacman -S --noconfirm --needed"
      pynvim_pkg="python-pynvim"
  elif hash dnf 2>/dev/null; then
      # Fedora
      dnf -y install sudo || true
      sudo dnf -y upgrade
      sudo dnf -y group install 'Development Tools'
      sudo dnf -y install util-linux-user direnv
      pacman_bin="dnf -y install"
      pynvim_pkg="python3-neovim"
  elif hash apt-get 2>/dev/null; then
      # Debian/Ubuntu
      export DEBIAN_FRONTEND=noninteractive
      apt-get -y update || true
      apt-get -y install sudo || true
      sudo -E apt-get -y update
      sudo -E apt-get -y upgrade
      sudo -E apt-get -y install build-essential libpam-systemd direnv
      pacman_bin="DEBIAN_FRONTEND=noninteractive apt-get -y install"
      pynvim_pkg="python3-neovim"
  else
      pacman_bin=/bin/false
  fi

  # install basic packages
  sudo $pacman_bin git neovim ${pynvim_pkg} zsh tmux htop zip unzip mc xsel curl trash-cli
fi

# get submodules
git submodule init
git submodule update --recursive

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

# copy terminator config
mkdir -vp ~/.config/terminator
ln -srfv _terminator_config ~/.config/terminator/config

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

# copy environment
mkdir -vp ~/.config/environment.d/
ln -srfv ssh-agent-env.conf ~/.config/environment.d/ssh-agent.conf

# copy binaries
mkdir -vp ~/bin
ln -srfv bin/* ~/bin/

# copy ssh config
mkdir -vp ~/.ssh
ln -srfv _ssh_config ~/.ssh/config

# copy ssh-key agent (if not in docker)
if [ ! -f /.dockerenv ]; then
    mkdir -vp ~/.config/systemd/user
    ln -srfv systemd-templates/ssh-agent.service ~/.config/systemd/user
    systemctl --user enable ssh-agent.service
    systemctl --user start ssh-agent.service
fi
