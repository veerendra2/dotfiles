#!/usr/bin/env bash

set -e

# Keep the list of dotfiles in one place
declare -a dotfiles=(
  "bash"
  "curl"
  "vim"
  "git"
  "screen"
)

# Help message and options
if [[ "$1" == "--help" || "$1" == "-h" ]]; then
  echo "Usage: $0 [option]"
  echo
  echo "Options:"
  echo "  -i, --install      Install dotfiles (default)"
  echo "  -r, --re-stow      Re-stow dotfiles (update symbolic links)"
  echo "  -d, --delete       Delete dotfiles (uninstall)"
  echo "  -h, --help         Show this help message"
  exit 0
fi

# Determine the action based on the command-line argument
ACTION=${1:-"-i"}

case "$ACTION" in
  "-d"|"--delete")
    pushd ~/projects/dotfiles > /dev/null
    for pkg in "${dotfiles[@]}"; do
        stow -D -t "${HOME}" "$pkg"
    done
    stow -D -t "${HOME}/.config" --no-folding .config
    echo "[.] Dotfiles uninstalled!"
    exit 0
    ;;

  "-r"|"--re-stow")
    pushd ~/projects/dotfiles > /dev/null
    for pkg in "${dotfiles[@]}"; do
        stow -R -t "${HOME}" "$pkg"
    done
    stow -R -t "${HOME}/.config" --no-folding .config
    echo "[*] Dotfiles re-stowed!"
    exit 0
    ;;

  "-i"|"--install")
    case "$(uname -s)" in
      "Darwin")
        brew install stow openssl pv direnv
        ;;
      "Linux")
        sudo apt-get update && sudo apt-get install -y stow curl feh xclip openssl direnv
        ;;
    esac

    mkdir -p "${HOME}"/{projects,.config}

    pushd "${HOME}/projects" > /dev/null

    if [[ ! -d "${HOME}/projects/dotfiles"  ]]; then
        ssh-keyscan github.com >> ~/.ssh/known_hosts
        git clone https://github.com/veerendra2/prepare-my-machine.git dotfiles
    fi

    pushd dotfiles > /dev/null
    git pull

    touch bash/.extra .extra-gitconfig

    for pkg in "${dotfiles[@]}"; do
      stow -t "${HOME}" "$pkg"
    done
    stow -t "${HOME}/.config" --no-folding .config
    echo "[*] Dotfiles installed!"
    ;;

  *)
    echo "Invalid option: $1"
    echo "Run '$0 --help' for usage."
    exit 1
    ;;
esac
