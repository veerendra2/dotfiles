#!/bin/bash
echo "[*] Installing Dependency Packages"
sudo apt-get update && sudo apt-get install curl feh xclip i3lock ngrep pv openssl python3-pip -y
pip3 install spotify-cli-linux
for x in .aliases .bash_profiles .bash_prompt .bashrc .curlrc .dockerfunctions .exports .functions .path .screenrc;
do
  echo "[*] Downloading to $HOME/$x"
  curl -qo $HOME/$x https://raw.githubusercontent.com/veerendra2/dotfiles/master/$x > /dev/null 2>&1
done
