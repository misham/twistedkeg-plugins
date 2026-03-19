# Git Merge Support

The `kb setup-git` command configures git to handle `kb.db` merge conflicts automatically.

## Setup

```bash
${CLAUDE_PLUGIN_ROOT}/bin/kb setup-git --db kb.db
```

This is run automatically by the SessionStart hook (`scripts/install-kb.sh`). It configures:

- A custom git merge driver in `.git/config`
- A merge tool for manual resolution

## How the Merge Driver Works

When branches both modify `kb.db`, the driver:

1. Matches documents by `(type, title)` tuple
2. Keeps the version with the later `updated_at` timestamp
3. Incorporates new documents from both branches with original timestamps
4. Remaps document links to merged IDs

## Manual Resolution

If automatic merging fails, use:

```bash
git mergetool --tool=kb
```

## Prerequisite

The `.gitattributes` file must contain:

```
*.db merge=kb
```

Without this line, the merge driver will not activate. The SessionStart hook warns if this is missing.
