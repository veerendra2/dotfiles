#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROFILE="${1:-}"

usage() {
  printf 'Usage: %s [server|desktop]\n' "${0##*/}"
}

detect_profile() {
  if [ -n "${DISPLAY:-}" ] || [ -n "${WAYLAND_DISPLAY:-}" ]; then
    echo "desktop"
    return
  fi

  if command -v dpkg >/dev/null 2>&1; then
    if dpkg -l | grep -E -q 'ubuntu-desktop|kubuntu-desktop|lubuntu-desktop|xubuntu-desktop|gnome-shell|gdm3|lightdm|xfce4|kde-plasma' 2>/dev/null; then
      echo "desktop"
      return
    fi
  fi

  echo "server"
}

if [ -z "$PROFILE" ]; then
  PROFILE="$(detect_profile)"
fi

install_apt_bundle() {
  if command -v apt-bundle >/dev/null 2>&1; then
    return
  fi

  curl -fsSL https://raw.githubusercontent.com/apt-bundle/apt-bundle/main/install.sh | sudo bash
}

install_aptfile() {
  local aptfile="$1"

  if [ -f "$aptfile" ]; then
    sudo apt-bundle --file "$aptfile"
  fi
}

install_snapfile() {
  local snapfile="$1"

  if [ ! -f "$snapfile" ]; then
    return
  fi

  if ! command -v snap >/dev/null 2>&1; then
    sudo apt-get update
    sudo apt-get install -y snapd
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

install_homebrew() {
  if command -v brew >/dev/null 2>&1; then
    return
  fi

  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  
  # Evaluate Homebrew shell environment for the current process
  if [ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  fi
}

install_brewfile() {
  local brewfile="$1"

  if [ -f "$brewfile" ]; then
    install_homebrew
    
    # Pre-emptively trust any taps defined in the Brewfile to prevent interactive aborts
    if command -v brew >/dev/null 2>&1; then
      local taps
      taps="$(grep -E '^tap ' "$brewfile" | cut -d '"' -f2 || true)"
      if [ -n "$taps" ]; then
        while IFS= read -r tap; do
          [ -z "$tap" ] && continue
          brew tap "$tap" || true
          brew trust "$tap" 2>/dev/null || true
        done <<< "$taps"
      fi
    fi

    brew bundle --file "$brewfile"
  fi
}

install_pipxfile() {
  local pipxfile="$1"

  if [ ! -f "$pipxfile" ]; then
    return
  fi

  if command -v pipx >/dev/null 2>&1; then
    # Force pipx to configure its directories
    pipx ensurepath --force >/dev/null 2>&1
    # Prepend pipx binary path directly to the running installer process
    export PATH="${HOME}/.local/bin:${PATH}"

    while IFS= read -r line || [ -n "$line" ]; do
      case "$line" in
        ''|'#'*) continue ;;
      esac

      # shellcheck disable=SC2086
      pipx install $line --force || true
    done < "$pipxfile"
  fi
}

detect_gpu_vendors() {
  if ! command -v lspci >/dev/null 2>&1; then
    return
  fi

  local devices
  devices="$(lspci | grep -Ei 'vga|3d|2d' || true)"

  if printf '%s\n' "$devices" | grep -qi nvidia; then
    printf '%s\n' nvidia
  fi

  if printf '%s\n' "$devices" | grep -Eqi 'amd|ati'; then
    printf '%s\n' amd
  fi

  if printf '%s\n' "$devices" | grep -qi intel; then
    printf '%s\n' intel
  fi
}

install_gpu_packages() {
  local vendors vendor
  vendors="$(detect_gpu_vendors)"

  if [ -z "$vendors" ]; then
    return
  fi

  install_aptfile "$ROOT_DIR/server/gpu/Aptfile.gpu"

  while IFS= read -r vendor; do
    install_aptfile "$ROOT_DIR/server/gpu/Aptfile.$vendor"

    if [ "$vendor" = "nvidia" ] && command -v ubuntu-drivers >/dev/null 2>&1; then
      sudo ubuntu-drivers autoinstall
    fi
  done <<< "$vendors"
}

case "$PROFILE" in
  server|desktop) ;;
  *)
    usage >&2
    exit 2
    ;;
esac

install_apt_bundle
install_aptfile "$ROOT_DIR/server/Aptfile"
install_brewfile "$ROOT_DIR/server/Brewfile"
install_pipxfile "$ROOT_DIR/../tools/Pipxfile"

if [ "$PROFILE" = "desktop" ]; then
  install_aptfile "$ROOT_DIR/desktop/Aptfile"
  install_gpu_packages
  install_brewfile "$ROOT_DIR/desktop/Brewfile"
  install_snapfile "$ROOT_DIR/desktop/Snapfile"
fi
