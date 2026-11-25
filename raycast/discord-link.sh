#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Paste Link Without Embed
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🔗
# @raycast.packageName Discord
# @raycast.argument1 { "type": "text", "placeholder": "link text (optional)", "optional": true }

# Documentation:
# @raycast.description Pastes the copied URL as [text](<url>), or <url> with no text. The angle brackets stop Discord from adding a preview embed.

set -euo pipefail

# Clipboard URL without surrounding whitespace or trailing newlines
url="$(pbpaste | tr -d '\r' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
# Already wrapped by an earlier run: unwrap so it is not wrapped twice
url="${url#<}"
url="${url%>}"

if [[ ! "$url" =~ ^https?://[^[:space:]]+$ ]]; then
  echo "The clipboard has no URL"
  exit 1
fi

text="${1:-}"
if [ -n "$text" ]; then
  # Brackets in the text would end the markdown link early
  text="${text//[/\\[}"
  text="${text//]/\\]}"
  formatted="[$text](<$url>)"
else
  formatted="<$url>"
fi

printf '%s' "$formatted" | pbcopy
# Raycast closes before the script runs; the short delay lets focus return to Discord
osascript -e 'delay 0.1' -e 'tell application "System Events" to keystroke "v" using command down'
