#!/bin/bash
set -euo pipefail

PLUGIN_ROOT="${CLAUDE_PLUGIN_ROOT:-$(cd "$(dirname "$0")/.." && pwd)}"
LNR_BIN="${PLUGIN_ROOT}/bin/lnr"
REPO="misham/lnr"

# Get latest version
LATEST_VERSION=$(curl -fsSL "https://api.github.com/repos/${REPO}/releases/latest" | grep -o '"tag_name": "[^"]*"' | cut -d'"' -f4)

if [ -z "$LATEST_VERSION" ]; then
  echo "Warning: Could not fetch latest lnr version" >&2
  exit 0
fi

# Check current version
if [ -x "$LNR_BIN" ]; then
  CURRENT_VERSION=$("$LNR_BIN" --version 2>/dev/null | head -1 | awk '{print $NF}' || echo "")
  if [ "$CURRENT_VERSION" = "$LATEST_VERSION" ]; then
    # Binary is up to date, just check auth
    if ! "$LNR_BIN" auth status >/dev/null 2>&1; then
      echo "lnr: Not authenticated. Run /issue-manager:login to authenticate with Linear." >&2
    fi
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
if ! curl -fsSL "https://github.com/${REPO}/releases/download/${LATEST_VERSION}/lnr-${OS}-${ARCH}" -o "$LNR_BIN"; then
  echo "Warning: Failed to download lnr binary" >&2
  exit 0
fi

chmod +x "$LNR_BIN"

# Verify
if ! "$LNR_BIN" --version >/dev/null 2>&1; then
  echo "Warning: lnr binary verification failed" >&2
  rm -f "$LNR_BIN"
  exit 0
fi

# Check auth status
if ! "$LNR_BIN" auth status >/dev/null 2>&1; then
  echo "lnr: Not authenticated. Run /issue-manager:login to authenticate with Linear." >&2
fi
