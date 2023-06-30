#!/usr/bin/env bash

mkdir -p ~/projects

pushd ~/projects > /dev/null
git clone git@github.com:veerendra2/dotfiles.git

pushd dotfiles > /dev/null
git pull

for file in $(find ${PWD} -name ".*" -not -name ".gitignore" -not -name ".git" -not -name ".config" -not -name ".github" -not -name ".*.swp" -not -name ".gnupg");
do
	f=$(basename $file);
	ln -sfn $file ${HOME}/$f;
done
