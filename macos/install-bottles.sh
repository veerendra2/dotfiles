#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BREWFILE="$ROOT_DIR/Brewfile"

brew bundle list --file "$BREWFILE" --tap | while IFS= read -r tap; do
  brew tap "$tap"
done

brew bundle list --file "$BREWFILE" --formula | while IFS= read -r formula; do
  brew install --force-bottle "$formula"
done
