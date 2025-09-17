#!/usr/bin/env bash

set -e

declare -a dotfiles=(
  "bash"
  "curl"
  "git"
  "screen"
)
declare -a dotfiles_no_folding=(
  ".config"
  ".vim"
)

# A function to handle the stowing process
function stow_dotfiles() {
    local action=${1}
    pushd ~/projects/dotfiles > /dev/null

    for pkg in "${dotfiles[@]}"; do
        stow "${action}" -t "${HOME}" "$pkg"
    done
    for pkg in "${dotfiles_no_folding[@]}"; do
        stow "${action}" -t "${HOME}/${pkg}" --no-folding "$pkg"
    done
    popd > /dev/null
}

ACTION=${1:-"stow"}

if [[ "$1" == "-i" ]]; then
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
    ACTION="stow"
fi

case "$ACTION" in
  "-d"|"--delete")
    stow_dotfiles "-D"
    echo "[.] Dotfiles uninstalled!"
    ;;
  "-r"|"--re-stow")
    stow_dotfiles "-R"
    echo "[*] Dotfiles re-stowed!"
    ;;
  "stow")
    mkdir -p "${HOME}"/{projects,.config,.vim}
    pushd "${HOME}/projects" > /dev/null
    if [[ ! -d "dotfiles"  ]]; then
        ssh-keyscan github.com >> ~/.ssh/known_hosts
        git clone https://github.com/veerendra2/dotfiles.git
    fi
    pushd dotfiles > /dev/null
    git pull > /dev/null
    touch {bash/.extra,git/.extra-gitconfig}
    stow_dotfiles
    echo "[*] Dotfiles installed!"
    ;;
  "--help"|"-h")
    echo "Usage: $0 [option]"
    echo
    echo "Options:"
    echo "  -i      Install dependency packages and stow dotfiles"
    echo "  -r      Re-stow dotfiles"
    echo "  -d      Delete dotfiles"
    echo "  -h      Show this help message"
    ;;
  *)
    echo "Invalid option: $1"
    echo "Run '$0 --help' for usage."
    exit 1
    ;;
esac
