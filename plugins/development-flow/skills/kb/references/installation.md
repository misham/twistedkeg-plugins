# KB Installation

The kb binary is auto-installed and updated by a SessionStart hook defined in `hooks/hooks.json`.

## How It Works

The hook runs `${CLAUDE_PLUGIN_ROOT}/scripts/install-kb.sh` at session start. The script:

1. Fetches the latest release version from `github.com/misham/kb`
2. Compares against the currently installed version (if any)
3. Skips download if already up to date
4. Detects platform (linux/darwin) and architecture (amd64/arm64)
5. Downloads the binary to `${CLAUDE_PLUGIN_ROOT}/bin/kb`
6. Verifies the binary runs successfully
7. Runs `kb setup-git` to configure git merge support (if in a git repo)

## Binary Location

```
${CLAUDE_PLUGIN_ROOT}/bin/kb
```

The `bin/` directory is created automatically if it doesn't exist.

## Failure Behavior

All failures are non-fatal (exit 0 with a warning to stderr):
- Cannot fetch latest version → skips update
- Download fails → skips update
- Binary verification fails → removes the bad binary

This ensures a failed kb update never blocks session startup.

## Manual Installation

If automatic installation fails, download manually:

```bash
curl -fsSL "https://github.com/misham/kb/releases/latest/download/kb-$(uname -s | tr '[:upper:]' '[:lower:]')-$(uname -m | sed 's/x86_64/amd64/;s/aarch64/arm64/')" -o "${CLAUDE_PLUGIN_ROOT}/bin/kb"
chmod +x "${CLAUDE_PLUGIN_ROOT}/bin/kb"
```

## Post-Installation

After installation, the script automatically runs git merge setup. See [Git Merge Support](git-merge-support.md) for details.
