#!/usr/bin/env bash

sudo apt-get update
sudo apt-get install curl feh xclip ngrep pv openssl python3-pip -y

sudo curl -qo /usr/local/bin/yq https://github.com/mikefarah/yq/releases/download/v4.27.2/yq_freebsd_amd64 > /dev/null 2>&1
sudo chmod +x /usr/local/bin/yq

for x in .aliases .bash_profiles .bash_prompt .bashrc .curlrc .dockerfunctions .exports .functions .path .screenrc .k8s .vimrc;
do
  echo "[*] Downloading to $HOME/$x"
  curl -qo $HOME/$x https://raw.githubusercontent.com/veerendra2/dotfiles/master/$x > /dev/null 2>&1
done
