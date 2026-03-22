# Import and Cleanup

For import workflows that involve deleting source files after import, use the safety script instead of calling `kb import` directly.

## Safety Script

```bash
${CLAUDE_PLUGIN_ROOT}/scripts/kb_import_and_cleanup.sh <type> <file_to_import> [files_to_delete...]
```

### Arguments

- **type** — kb document type: `plan`, `research`, or `requirements`
- **file_to_import** — markdown file to import into kb
- **files_to_delete** — additional files to remove after successful import (the imported file is always deleted)

### What the Script Does

1. Imports the file into kb
2. Extracts the new document ID from import output
3. Retrieves the document back and verifies it has content (minimum 50 chars)
4. Only deletes source files after successful verification
5. Prints the kb document ID

### Output

```
Successfully imported as kb document <id> (type: <type>)
Verified: <length> chars retrieved
Deleted <count> file(s): <list>
KB_DOC_ID=<id>
```

## Rules

- **Never delete files manually before verifying the kb import** — always use the script
- Requirements files are imported during `/gather_requirements` — when compacting a plan, include requirements files in the cleanup script call only for file deletion, not re-import
- After import, link the new document to related documents using `kb link`

## Typical Workflows

### Research Import

```bash
kb import docs/ai/research/<filename>.md -t research --db kb.db --plain
kb link <new_id> <related_id> -r related --db kb.db --plain
```

### Requirements Import

```bash
kb import docs/ai/requirements/<filename>.md -t requirements --db kb.db --plain
kb link <new_id> <related_id> -r related --db kb.db --plain
```

### Plan Compaction (with cleanup)

```bash
${CLAUDE_PLUGIN_ROOT}/scripts/kb_import_and_cleanup.sh plan <plan_file> [research_files...] [requirements_files...]
kb link <new_plan_id> <research_id> -r related --db kb.db --plain
```
