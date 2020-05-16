#!/usr/bin/env bash

echo "##########################################"
echo "#     👨‍💻SAY HELLO TO YOUR NEW MAC 👨‍💻     #"
echo "##########################################"

read -p "Your name: " name
read -p "Email Address: " email
read -p "Enter to continue..."

PWD=`pwd`

setup_ssh() {
  set -- $PWD/keys/id_rsa*
  if [[ -f $1 ]]; then
    echo "Found ssh keys, setting up .ssh folder..."
    mkdir -p ~/.ssh
    cp $PWD/keys/id_rsa* ~/.ssh/
    chmod 644 ~/.ssh/id_rsa*
    chmod 700 ~/.ssh
  fi
}

setup_xcode() {
  echo 'Installing command line tools...'
  xcode-select --install
}

setup_homebrew() {
  command -v brew > /dev/null 2>&1 || {
    echo "Installing homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
  }
}

setup_softwares() {
  echo "Installing softwares..."
  cat $PWD/brew/brew_tap | xargs -L 1 brew tap
  cat $PWD/brew/brew_list | xargs -L 1 brew install
  cat $PWD/brew/brew_cask_list | xargs -L 1 brew cask install

  brew cask cleanup
  brew cleanup
}

setup_dotfiles() {
  echo "Setting up dot files..."
  cp $PWD/dot_files/* ~/
}

setup_git() {
  echo "Configuring git..."
  git config --global user.name "$name"
  git config --global user.email "$email"
  git config --global core.editor "vim"
}

setup_vim() {
  echo 'Setting up ultimate vimrc...'
  git clone --depth=1 https://github.com/amix/vimrc.git ~/.vim_runtime
  sh ~/.vim_runtime/install_basic_vimrc.sh
}

setup_zsh() {
  echo 'Installig Oh-My-Zsh...'
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  
  echo 'Installig powerlevel10 theme...'
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k

  chsh -s /bin/zsh # need to enter password
}

setup() {
  setup_ssh
  setup_xcode
  setup_homebrew
  setup_softwares
  setup_git
  setup_vim
  setup_zsh

  echo '✨Setup is done, enjoy ✨'
}

setup