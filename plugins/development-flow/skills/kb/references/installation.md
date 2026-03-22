# KB Installation

The `kb` binary must be installed in your system PATH before using the development-flow plugin. The SessionStart hook verifies it is available at session start.

## How It Works

The hook runs `${CLAUDE_PLUGIN_ROOT}/scripts/check-kb.sh` at session start. The script:

1. Checks whether `kb` is available in PATH via `command -v kb`
2. Warns if not found, with instructions to install
3. Runs `kb setup-git` to configure git merge support (if in a git repo)

## Manual Installation

Download the binary from the GitHub releases page and place it in your PATH:

1. Go to `https://github.com/misham/kb/releases`
2. Download the binary for your platform (e.g., `kb-darwin-arm64`, `kb-linux-amd64`)
3. Place it in your PATH and make it executable:

```bash
# Example for macOS arm64:
curl -fsSL "https://github.com/misham/kb/releases/latest/download/kb-darwin-arm64" -o /usr/local/bin/kb
chmod +x /usr/local/bin/kb
```

Or for any platform using uname detection:

```bash
curl -fsSL "https://github.com/misham/kb/releases/latest/download/kb-$(uname -s | tr '[:upper:]' '[:lower:]')-$(uname -m | sed 's/x86_64/amd64/;s/aarch64/arm64/')" -o /usr/local/bin/kb
chmod +x /usr/local/bin/kb
```

## Post-Installation

After installation, the SessionStart hook automatically runs git merge setup. See [Git Merge Support](git-merge-support.md) for details.
