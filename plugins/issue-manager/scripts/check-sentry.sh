#!/bin/bash
set -euo pipefail

# Verify sentry-cli is available in PATH
if ! command -v sentry-cli >/dev/null 2>&1; then
  echo "Warning: sentry-cli not found in PATH. Install it from https://docs.sentry.io/cli/installation/" >&2
  echo "  Follow the instructions for your platform to install sentry-cli" >&2
  exit 0
fi

# Check auth status
if ! sentry-cli info --no-defaults >/dev/null 2>&1; then
  echo "sentry-cli: Not authenticated. Run /issue-manager:sentry-login to authenticate with Sentry." >&2
fi
