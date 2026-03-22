#!/bin/bash
set -euo pipefail

# Verify kb is available in PATH
if ! command -v kb >/dev/null 2>&1; then
  echo "Warning: kb not found in PATH. Install it from https://github.com/misham/kb/releases" >&2
  echo "  Download the binary for your platform and place it in your PATH (e.g., /usr/local/bin/kb)" >&2
  exit 0
fi

# Setup git merge support if in a git repo
if [ -n "${CLAUDE_PROJECT_DIR:-}" ] && [ -d "${CLAUDE_PROJECT_DIR}/.git" ]; then
  kb setup-git --db "${CLAUDE_PROJECT_DIR}/kb.db" 2>/dev/null || true
fi
