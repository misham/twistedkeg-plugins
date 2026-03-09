# KB CLI Usage

The `kb` CLI is available at `${CLAUDE_PLUGIN_ROOT}/bin/kb`. The database path should always be specified with `--db kb.db` relative to the project root. Use `--plain` for machine-readable output.

## Commands

### Search
```bash
${CLAUDE_PLUGIN_ROOT}/bin/kb search "<query>" --db kb.db --plain
${CLAUDE_PLUGIN_ROOT}/bin/kb search "<query>" -t research --db kb.db --plain
${CLAUDE_PLUGIN_ROOT}/bin/kb search "<query>" -t plan --db kb.db --plain
```

### Get document by ID
```bash
${CLAUDE_PLUGIN_ROOT}/bin/kb get <id> --db kb.db --plain
```

### List documents
```bash
${CLAUDE_PLUGIN_ROOT}/bin/kb list --db kb.db --plain
${CLAUDE_PLUGIN_ROOT}/bin/kb list -t research --db kb.db --plain
```

### Import
```bash
${CLAUDE_PLUGIN_ROOT}/bin/kb import <file> -t research --db kb.db --plain
```

### Link documents
```bash
${CLAUDE_PLUGIN_ROOT}/bin/kb link <id1> <id2> -r related --db kb.db --plain
```

### Show links
```bash
${CLAUDE_PLUGIN_ROOT}/bin/kb links <id> --db kb.db --plain
```

## Import and Cleanup

Use the safety script for import-then-delete workflows:

```bash
${CLAUDE_PLUGIN_ROOT}/scripts/kb_import_and_cleanup.sh <type> <file_to_import> [files_to_delete...]
```

The script:
1. Imports the file into kb
2. Extracts the new document ID
3. Retrieves and verifies the document has content (min 50 chars)
4. Only deletes source files after successful verification
5. Prints the kb document ID

**Never delete files manually before verifying the kb import.**

## Git Merge Support

The `kb setup-git` command configures git to handle `kb.db` merge conflicts automatically:

```bash
${CLAUDE_PLUGIN_ROOT}/bin/kb setup-git --db kb.db
```

This is run automatically by the SessionStart hook. When branches both modify `kb.db`, the merge driver:
- Matches documents by `(type, title)` tuple
- Keeps the version with the later `updated_at` timestamp
- Incorporates new documents from both branches with original timestamps
- Remaps document links to merged IDs

If automatic merging fails, use `git mergetool --tool=kb` for manual resolution.
