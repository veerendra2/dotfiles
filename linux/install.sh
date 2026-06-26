#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROFILE="${1:-server}"

usage() {
  printf 'Usage: %s [server|desktop]\n' "${0##*/}"
}

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
}

install_brewfile() {
  local brewfile="$1"

  if [ -f "$brewfile" ]; then
    install_homebrew
    brew bundle --file "$brewfile"
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

if [ "$PROFILE" = "desktop" ]; then
  install_aptfile "$ROOT_DIR/desktop/Aptfile"
  install_gpu_packages
  install_brewfile "$ROOT_DIR/desktop/Brewfile"
  install_snapfile "$ROOT_DIR/desktop/Snapfile"
fi
