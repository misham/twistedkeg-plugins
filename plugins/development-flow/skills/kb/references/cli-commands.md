# KB CLI Commands

All commands use `${CLAUDE_PLUGIN_ROOT}/bin/kb` as the binary path and require `--db kb.db --plain`.

## Search

Find documents by query, optionally filtered by type.

```bash
# Search all document types
${CLAUDE_PLUGIN_ROOT}/bin/kb search "<query>" --db kb.db --plain

# Search by type
${CLAUDE_PLUGIN_ROOT}/bin/kb search "<query>" -t research --db kb.db --plain
${CLAUDE_PLUGIN_ROOT}/bin/kb search "<query>" -t plan --db kb.db --plain
${CLAUDE_PLUGIN_ROOT}/bin/kb search "<query>" -t requirements --db kb.db --plain
```

Returns documents with IDs, titles, and relevance scores.

## Get

Retrieve a document by its ID.

```bash
${CLAUDE_PLUGIN_ROOT}/bin/kb get <id> --db kb.db --plain
```

Fetch full content of documents found via `search` or `list`.

## List

List all documents, optionally filtered by type.

```bash
${CLAUDE_PLUGIN_ROOT}/bin/kb list --db kb.db --plain
${CLAUDE_PLUGIN_ROOT}/bin/kb list -t research --db kb.db --plain
${CLAUDE_PLUGIN_ROOT}/bin/kb list -t plan --db kb.db --plain
${CLAUDE_PLUGIN_ROOT}/bin/kb list -t requirements --db kb.db --plain
```

## Import

Import a markdown file as a kb document.

```bash
${CLAUDE_PLUGIN_ROOT}/bin/kb import <file> -t <type> --db kb.db --plain
```

Output format: `Imported document <id>: <title>`

For import workflows that include file cleanup, use the [safe import script](import-and-cleanup.md) instead of calling `kb import` directly.

## Link

Create a relationship between two documents.

```bash
${CLAUDE_PLUGIN_ROOT}/bin/kb link <id1> <id2> -r related --db kb.db --plain
```

After importing, connect related documents (e.g., link a plan to its research).

## Show Links

Display all documents linked to a given document.

```bash
${CLAUDE_PLUGIN_ROOT}/bin/kb links <id> --db kb.db --plain
```

## Version

Check the installed kb version.

```bash
${CLAUDE_PLUGIN_ROOT}/bin/kb version
```
