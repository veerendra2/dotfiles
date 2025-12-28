#!/usr/bin/env bash

set -e

# List of dotfiles directories
declare -a dotfiles=(
  "bash"
  "curl"
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
    stow -D -t "${HOME}/.vim" --no-folding .vim
    stow -D -t "${HOME}/.ssh" --no-folding .ssh
    echo "[.] Dotfiles uninstalled!"
    exit 0
    ;;

  "-r"|"--re-stow")
    pushd ~/projects/dotfiles > /dev/null
    for pkg in "${dotfiles[@]}"; do
        stow -R -t "${HOME}" "$pkg"
    done
    stow -R -t "${HOME}/.config" --no-folding .config
    stow -R -t "${HOME}/.vim" --no-folding .vim
    stow -R -t "${HOME}/.ssh" --no-folding .ssh
    echo "[*] Dotfiles re-stowed!"
    exit 0
    ;;

  "-i"|"--install")
    case "$(uname -s)" in
      "Darwin")
        brew install stow openssl starship navi fd fzf font-commit-mono-nerd-font pyenv
        # Python build dependencies - pyenv
        # https://github.com/pyenv/pyenv/wiki#suggested-build-environment
        brew install readline sqlite3 xz tcl-tk@8 libb2 zstd zlib pkgconfig
        ;;
      "Linux")
        sudo -v
        apt-get update
        apt-get install -y stow fd-find fzf curl feh xclip openssl
        # Python build dependencies - pyenv
        # https://github.com/pyenv/pyenv/wiki#suggested-build-environment
        apt-get install -y make build-essential libssl-dev zlib1g-dev \
            libbz2-dev libreadline-dev libsqlite3-dev \
            libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev \
            libffi-dev liblzma-dev
        # Install starship
        curl -fsSL https://starship.rs/install.sh | sh -s -- --yes
        # Install navi
        curl -fsSL https://raw.githubusercontent.com/denisidoro/navi/master/scripts/install | bash
        # Install pyenv
        curl -fsSL https://pyenv.run | bash
        ;;
    esac

    mkdir -p "${HOME}"/{projects,.config,.vim,.ssh,.ssh/config.d}

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
    touch {bash/.extra,git/.extra-gitconfig}

    for pkg in "${dotfiles[@]}"; do
      stow -t "${HOME}" "$pkg"
    done
    stow -t "${HOME}/.config" --no-folding .config
    stow -t "${HOME}/.vim" --no-folding .vim
    stow -t "${HOME}/.ssh" --no-folding .ssh
    echo "[*] Dotfiles installed!"
    ;;

  *)
    echo "Invalid option: $1"
    echo "Run '$0 --help' for usage."
    exit 1
    ;;
esac
