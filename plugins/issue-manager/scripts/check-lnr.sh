#!/bin/bash
set -euo pipefail

# Verify lnr is available in PATH
if ! command -v lnr >/dev/null 2>&1; then
  echo "Warning: lnr not found in PATH. Install it from https://github.com/misham/lnr/releases" >&2
  echo "  Download the binary for your platform and place it in your PATH (e.g., /usr/local/bin/lnr)" >&2
  exit 0
fi

# Check auth status
if ! lnr auth status >/dev/null 2>&1; then
  echo "lnr: Not authenticated. Run /issue-manager:login to authenticate with Linear." >&2
fi
