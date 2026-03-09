---
event: SessionStart
allowed-tools: Bash
---

# KB Binary Installer

Ensure the `kb` CLI binary is available at `${CLAUDE_PLUGIN_ROOT}/bin/kb` and up to date with the latest release.

## Configuration

- **Repository:** misham/kb
- **Download base URL:** https://github.com/misham/kb/releases/download

## Process

1. Query the latest release version from GitHub:
   ```bash
   LATEST_VERSION=$(curl -fsSL "https://api.github.com/repos/misham/kb/releases/latest" | grep -o '"tag_name": "[^"]*"' | cut -d'"' -f4)
   ```

2. Check if `${CLAUDE_PLUGIN_ROOT}/bin/kb` exists and get its current version:
   ```bash
   CURRENT_VERSION=""
   if test -x "${CLAUDE_PLUGIN_ROOT}/bin/kb"; then
     CURRENT_VERSION=$("${CLAUDE_PLUGIN_ROOT}/bin/kb" version 2>/dev/null || echo "")
   fi
   ```

3. If the binary exists and version matches `$LATEST_VERSION`, do nothing.

4. If missing or version mismatch, detect platform and architecture:
   ```bash
   OS=$(uname -s | tr '[:upper:]' '[:lower:]')
   ARCH=$(uname -m)
   case "$ARCH" in
     x86_64) ARCH="amd64" ;;
     aarch64|arm64) ARCH="arm64" ;;
   esac
   ```

5. Download the correct binary:
   ```bash
   curl -fsSL "https://github.com/misham/kb/releases/download/${LATEST_VERSION}/kb-${OS}-${ARCH}" -o "${CLAUDE_PLUGIN_ROOT}/bin/kb"
   chmod +x "${CLAUDE_PLUGIN_ROOT}/bin/kb"
   ```

6. Verify the download:
   ```bash
   "${CLAUDE_PLUGIN_ROOT}/bin/kb" version
   ```

7. If download or verification fails, warn the user but do not block the session.

8. Ensure git merge support is configured for `kb.db`:
   ```bash
   "${CLAUDE_PLUGIN_ROOT}/bin/kb" setup-git --db kb.db
   ```
   This registers a git merge driver and mergetool in `.git/config` so that `kb.db` merge conflicts are resolved automatically (matching by `(type, title)`, keeping the later `updated_at` timestamp). Only needs to run once per repo, but is idempotent so safe to run every session.
