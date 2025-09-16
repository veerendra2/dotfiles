#!/usr/bin/env bash

set -e

# List of dotfiles directories
declare -a dotfiles=(
  "bash"
  "curl"
  "vim"
  "git"
  "screen"
)

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
        brew install stow openssl starship
        ;;
      "Linux")
        sudo apt-get update && sudo apt-get install -y stow curl feh xclip openssl
        # Install starship
        curl -sS https://starship.rs/install.sh | sh
        ;;
    esac

    mkdir -p "${HOME}"/{projects,.config}

    pushd "${HOME}/projects" > /dev/null

    # Clone dotfiles repo if not exists
    if [[ ! -d "dotfiles"  ]]; then
        ssh-keyscan github.com >> ~/.ssh/known_hosts
        git clone https://github.com/veerendra2/dotfiles.git
    fi

    pushd dotfiles > /dev/null

    # Just to make sure get latest changes in case script runs
    # in already cloned repo
    git pull

    # Create empty files to put machine specific/custom dotfiles
    # manually if needed. These extra dotfiles are not tracked in git
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
