#!/bin/bash
# Write macOS system defaults. Safe to run again: every write is idempotent.
cd "$(dirname "$0")"

[ "$(uname)" = "Darwin" ] || { echo "setup-macos.sh: not macOS, nothing to do"; exit 0; }

# Screenshots: save straight to the Desktop, no floating thumbnail.
# The thumbnail holds the file in memory until it is dismissed; without it
# the file is written the moment the shot is taken.
defaults write com.apple.screencapture location -string "$HOME/Desktop"
defaults write com.apple.screencapture show-thumbnail -bool false

# Apply the screencapture changes without a logout.
killall SystemUIServer 2>/dev/null
