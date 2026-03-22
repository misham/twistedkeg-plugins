# KB Usage for Research

See the consolidated [KB skill](../../kb/SKILL.md) for full CLI reference, import workflows, and git merge support.

## Research-Specific Patterns

### Searching for Prior Research

```bash
kb search "<query>" -t research --db kb.db --plain
```

### Importing Research Documents

```bash
kb import docs/ai/research/<filename>.md -t research --db kb.db --plain
kb link <new_id> <related_id> -r related --db kb.db --plain
```

### Import with Cleanup

Use the safety script — see [Import and Cleanup](../../kb/references/import-and-cleanup.md).
