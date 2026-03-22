# Cycle and Team Commands Reference

All commands require `--plain` for LLM output.

## Cycles (Sprints)

### List Cycles

```bash
lnr cycle list --plain
```

Display all cycles for the default team.

### Current Cycle

```bash
lnr cycle current --plain
```

Show the currently active cycle/sprint. Useful for understanding what work is in-flight.

### View Cycle

```bash
lnr cycle view <ID> --plain
```

Show cycle details including start/end dates, progress, and associated issues.

### Add Issue to Cycle

```bash
lnr cycle add-issue <ID> --plain
```

Add an issue to the current active cycle.

### Remove Issue from Cycle

```bash
lnr cycle remove-issue <ID> --plain
```

Remove an issue from its current cycle.

## Teams

### List Teams

```bash
lnr team list --plain
```

Display all available teams in the workspace.

### Set Default Team

```bash
lnr team set <name>
```

Configure the default team for all subsequent commands. Eliminates the need for `--team` on every call. Run this once per workspace setup.

## Workflow States

### List Workflow States

```bash
lnr state list --plain
```

Show all valid workflow states for the default team. States vary by team configuration (e.g., "Backlog", "Todo", "In Progress", "In Review", "Done", "Cancelled"). Useful for understanding what states are available when discussing issue transitions.
