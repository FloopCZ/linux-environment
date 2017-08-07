#!/bin/sh
set -e

# identify package manager, upgrade and install specific packages
if hash pacman 2>/dev/null; then
    # Arch linux
    pacman="pacman -S"
    sudo pacman -Syu || true
    sudo pacman -S neovim zsh zsh-completions || true
    # dual-booting
    #sudo pacman -S os-prober
elif hash yum 2>/dev/null; then
    pacman="yum install"
    sudo yum upgrade || true
    sudo yum groupinstall 'Development Tools' || true
    sudo yum install vim zsh || true
elif hash apt-get 2>/dev/null; then
    pacman="apt-get install"
    sudo apt-get update || true
    sudo apt-get upgrade || true
    sudo apt-get install build-essential vim zsh libpam-systemd || true
else
    pacman=/bin/false
fi

# install basic packages
sudo $pacman tmux htop zip unzip mc xsel curl || true

# get submodules
git submodule init
git submodule update

# copy neovim colorscheme and config
mkdir -vp ~/.config/nvim
mkdir -vp ~/.config/nvim/autoload
mkdir -vp ~/.config/nvim/bitmaps
mkdir -vp ~/.config/nvim/colors
mkdir -vp ~/.config/nvim/doc
ln -srfv base16-vim/colors/*.vim ~/.config/nvim/colors || true
ln -srfv _vimrc ~/.config/nvim/init.vim

# copy vim colorscheme and config
mkdir -vp ~/.vim
mkdir -vp ~/.vim/autoload
mkdir -vp ~/.vim/bitmaps
mkdir -vp ~/.vim/colors
mkdir -vp ~/.vim/doc
ln -srfv base16-vim/colors/*.vim ~/.vim/colors || true
ln -srfv _vimrc ~/.vimrc

# copy ideavim config
ln -srfv _vimrc ~/.ideavimrc

# copy zsh config
ln -srfv _zshrc ~/.zshrc
ln -srfv _zprofile ~/.zprofile

# install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# copy tmux config
ln -srfv _tmux.conf ~/.tmux.conf

# copy clang-format
ln -srfv _clang-format ~/.clang-format

# copy binaries
mkdir -vp ~/bin
ln -srfv bin/* ~/bin || true

# set up dropbox (https://wiki.archlinux.org/index.php/dropbox)
# 1. disable auto-update (so that systemd daemon works)
#rm -rf ~/.dropbox-dist
#install -dm0 ~/.dropbox-dist
# 2. allow more file watchers
#sudo echo "fs.inotify.max_user_watches = 100000" >> /etc/sysctl.d/99-sysctl.conf
#sudo sysctl --system
