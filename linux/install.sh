#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

install_aptfile() {
  local aptfile="$1"

    if [ -f "$aptfile" ]; then
    if ! command -v apt-bundle >/dev/null 2>&1; then
      echo "[*] Installing apt-bundle"
      sudo apt-get update && sudo apt-get install -y --no-install-recommends ca-certificates gnupg
      curl -fsSL https://raw.githubusercontent.com/apt-bundle/apt-bundle/main/install.sh | sudo bash
    fi

    sudo apt-bundle --file "$aptfile" 2> >(grep -v "Warning: Could not check if" >&2)
  fi
}

install_snapfile() {
  local snapfile="$1"

  if [ ! -f "$snapfile" ]; then
    return
  fi

  if ! command -v snap >/dev/null 2>&1; then
    echo "[.] snap cli not found"
    return
  fi

  while IFS= read -r line || [ -n "$line" ]; do
    case "$line" in
      ''|'#'*) continue ;;
    esac

    # shellcheck disable=SC2086
    sudo snap install $line

    if [ "${line%% *}" = "bitwarden" ]; then
      sudo snap connect bitwarden:password-manager-service || true
    fi
  done < "$snapfile"
}

install_brewfile() {
  local brewfile="$1"

  if [ -f "$brewfile" ]; then
    if ! command -v brew >/dev/null 2>&1; then
      NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    /home/linuxbrew/.linuxbrew/bin/brew bundle --file "$brewfile"
  fi
}

install_gpu_packages() {
  if ! command -v lspci >/dev/null 2>&1; then
    return
  fi

  if lspci | grep -Ei 'vga|3d|2d' | grep -qi nvidia; then
    echo "[*] NVIDIA GPU detected. Installing drivers..."
    sudo apt-get update && sudo apt-get install -y ubuntu-drivers-common
    sudo ubuntu-drivers autoinstall
  fi
}

install_aptfile "$ROOT_DIR/headless/Aptfile"
install_brewfile "$ROOT_DIR/headless/Brewfile"

if dpkg -l | grep -q 'ubuntu-desktop' 2>/dev/null; then
  install_aptfile "$ROOT_DIR/desktop/Aptfile"
  install_gpu_packages
  install_brewfile "$ROOT_DIR/desktop/Brewfile"
  install_snapfile "$ROOT_DIR/desktop/Snapfile"
fi
