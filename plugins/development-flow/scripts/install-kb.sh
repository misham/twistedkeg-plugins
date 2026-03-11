#!/bin/bash
set -euo pipefail

PLUGIN_ROOT="${CLAUDE_PLUGIN_ROOT:-$(cd "$(dirname "$0")/.." && pwd)}"
KB_BIN="${PLUGIN_ROOT}/bin/kb"
REPO="misham/kb"

# Get latest version
LATEST_VERSION=$(curl -fsSL "https://api.github.com/repos/${REPO}/releases/latest" | grep -o '"tag_name": "[^"]*"' | cut -d'"' -f4)

if [ -z "$LATEST_VERSION" ]; then
  echo "Warning: Could not fetch latest kb version" >&2
  exit 0
fi

# Check current version
if [ -x "$KB_BIN" ]; then
  CURRENT_VERSION=$("$KB_BIN" version 2>/dev/null | head -1 | awk '{print $2}' || echo "")
  if [ "$CURRENT_VERSION" = "$LATEST_VERSION" ]; then
    exit 0
  fi
fi

# Detect platform
OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)
case "$ARCH" in
  x86_64) ARCH="amd64" ;;
  aarch64|arm64) ARCH="arm64" ;;
esac

# Download
mkdir -p "${PLUGIN_ROOT}/bin"
if ! curl -fsSL "https://github.com/${REPO}/releases/download/${LATEST_VERSION}/kb-${OS}-${ARCH}" -o "$KB_BIN"; then
  echo "Warning: Failed to download kb binary" >&2
  exit 0
fi

chmod +x "$KB_BIN"

# Verify
if ! "$KB_BIN" version >/dev/null 2>&1; then
  echo "Warning: kb binary verification failed" >&2
  rm -f "$KB_BIN"
  exit 0
fi

# Setup git merge support if in a git repo
if [ -n "${CLAUDE_PROJECT_DIR:-}" ] && [ -d "${CLAUDE_PROJECT_DIR}/.git" ]; then
  "$KB_BIN" setup-git --db "${CLAUDE_PROJECT_DIR}/kb.db" 2>/dev/null || true
fi
