#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if ! command -v brew >/dev/null 2>&1; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

brew bundle --file "$ROOT_DIR/Brewfile"

# Prepend typical macOS Homebrew path if not set to find pipx
if [ -f "/opt/homebrew/bin/brew" ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -f "/usr/local/bin/brew" ]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

if command -v pipx >/dev/null 2>&1; then
  pipx ensurepath --force >/dev/null 2>&1
  export PATH="${HOME}/.local/bin:${PATH}"

  pipxfile="$ROOT_DIR/../tools/Pipxfile"
  if [ -f "$pipxfile" ]; then
    while IFS= read -r line || [ -n "$line" ]; do
      case "$line" in
        ''|'#'*) continue ;;
      esac

      pipx install $line --force || true
    done < "$pipxfile"
  fi
fi
