#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ "${LOCAL_HOMEBREW:-}" == "1" ]]; then
  brew bundle --file "$ROOT_DIR/Brewfile" --force-bottle
else
  brew bundle --file "$ROOT_DIR/Brewfile"
fi
