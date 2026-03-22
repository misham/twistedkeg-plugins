# Project and Initiative Commands Reference

All commands require `--plain` for LLM output.

## Projects

### List Projects

```bash
lnr project list --plain
```

Display all projects in the workspace.

### View Project

```bash
lnr project view <ID> --plain
```

Show project details including name, description, status, and progress.

### Project Issues

```bash
lnr project issues <ID> --plain
```

List all issues scoped to a specific project. Useful for understanding project progress and remaining work.

## Initiatives

### List Initiatives

```bash
lnr initiative list --plain
```

Display all initiatives in the workspace. Initiatives are higher-level groupings that contain projects.

### View Initiative

```bash
lnr initiative view <ID> --plain
```

Show initiative details including name, description, and status.

### Initiative Projects

```bash
lnr initiative projects <ID> --plain
```

List all projects linked to an initiative. Useful for understanding the breakdown of a strategic goal into actionable projects.
