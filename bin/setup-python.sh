#!/usr/bin/env bash
set -euo pipefail

# Find repository root directory (assumes script lives in bin/ or equivalent)
BIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$BIN_DIR/.." && pwd)"

# Ensure Homebrew paths are loaded if running standalone on macOS
if [[ "$(uname -s)" == "Darwin" ]]; then
  if [ -f "/opt/homebrew/bin/brew" ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [ -f "/usr/local/bin/brew" ]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
fi

# Ensure Homebrew paths are loaded if running standalone on Linux
if [[ "$(uname -s)" == "Linux" ]]; then
  if [ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  fi
fi

# 1. Install and Configure Python 3.14 via uv
if command -v uv >/dev/null 2>&1; then
  echo "[*] Installing Python 3.14 via uv..."
  uv python install 3.14
  mkdir -p "${HOME}/.local/bin"
  ln -sf "$(uv python find 3.14)" "${HOME}/.local/bin/python"
  ln -sf "$(uv python find 3.14)" "${HOME}/.local/bin/python3"
  echo "[+] Python 3.14 symlinked successfully under ~/.local/bin"
else
  echo "[!] uv not found. Please install uv first." >&2
  exit 1
fi

# 2. Configure pipx path and install global tools
if command -v pipx >/dev/null 2>&1; then
  echo "[*] Configuring pipx environment..."
  # Force pipx to configure its directories
  pipx ensurepath --force >/dev/null 2>&1
  # Prepend pipx binary path directly to the running installer process
  export PATH="${HOME}/.local/bin:${PATH}"

  pipxfile="$REPO_ROOT/tools/pipx/PipFile"
  if [ -f "$pipxfile" ]; then
    echo "[*] Installing PipFile packages from $pipxfile..."
    while IFS= read -r line || [ -n "$line" ]; do
      case "$line" in
        ''|'#'*) continue ;;
      esac

      # Install or force-upgrade packages
      pipx install "$line" --force || true
    done < "$pipxfile"
  else
    echo "[!] PipFile not found at $pipxfile" >&2
    exit 1
  fi
else
  echo "[!] pipx not found. Please install pipx first." >&2
  exit 1
fi
