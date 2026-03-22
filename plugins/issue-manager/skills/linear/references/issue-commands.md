# Issue Commands Reference

All commands require `--plain` for LLM output.

## Issues

### List Issues

```bash
lnr issue list --plain
lnr issue list --team <name> --plain
```

Lists issues for the default or specified team.

### View Issue

```bash
lnr issue view <ID> --plain
```

Display full issue details including title, description, state, assignee, labels, and priority.

### Create Issue

```bash
lnr issue create --title "<title>" --plain
lnr issue create --title "<title>" --description "<desc>" --priority 2 --plain
```

Create a new issue on the default team. Available flags: `--title` (required), `--description`, `--priority` (0=none, 1=urgent, 2=high, 3=medium, 4=low). The command returns the created issue ID.

### Update Issue

```bash
lnr issue update <ID> --title "<title>" --description "<desc>" --priority <0-4> --plain
```

Update issue properties. Available flags: `--title`, `--description`, `--priority` (0=none, 1=urgent, 2=high, 3=medium, 4=low). For state transitions, use `lnr issue close` or `lnr issue archive`.

### Close Issue

```bash
lnr issue close <ID> --plain
```

Transition an issue to the closed/done state.

### Archive Issue

```bash
lnr issue archive <ID> --plain
```

Archive a completed or abandoned issue.

### Search Issues

```bash
lnr issue search "<query>" --plain
```

Full-text search across all issues. Returns matching issues with their IDs and titles.

## Comments

### List Comments

```bash
lnr issue comment list <ID> --plain
```

Display all comments on an issue in chronological order.

### Add Comment

```bash
lnr issue comment add <ID> --body "<text>" --plain
```

Post a new comment to an issue. Use this for status updates, discussion, or linking context.

## Labels

### List Labels

```bash
lnr issue label list <ID> --plain
```

Show all labels assigned to an issue.

### Add Label

```bash
lnr issue label add <ID> --label "<name>" --plain
```

Apply a label to an issue. The label must exist in the workspace.
