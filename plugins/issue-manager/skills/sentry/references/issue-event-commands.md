# Issue and Event Commands Reference

All commands require `-o <org>` and `-p <project>` flags.

## Issues

### List Issues

```bash
sentry-cli issues list -o <org> -p <project>
sentry-cli issues list -o <org> -p <project> -s unresolved --max-rows 20
sentry-cli issues list -o <org> -p <project> --query "is:unresolved level:error"
sentry-cli issues list -o <org> -p <project> -i <ID>
```

List issues for a project. Available flags:

- `-s, --status <STATUS>` — filter by status: `resolved`, `muted`, `unresolved`
- `--query <QUERY>` — Sentry search query string (default: "")
- `-i, --id <ID>` — select a specific issue by ID
- `-a, --all` — select all issues (may be limited)
- `--max-rows <N>` — limit number of rows displayed
- `--pages <N>` — maximum pages to fetch, 100 issues/page (default: 5)

**Common query filters:**

| Filter | Example | Description |
|--------|---------|-------------|
| `is:unresolved` | `--query "is:unresolved"` | Unresolved issues only |
| `level:error` | `--query "level:error"` | Error-level issues |
| `level:fatal` | `--query "level:fatal"` | Fatal-level issues |
| `user.email:` | `--query "user.email:user@example.com"` | Issues affecting a specific user |
| `release:` | `--query "release:1.0.0"` | Issues in a specific release |
| `first-seen:` | `--query "first-seen:>2d"` | First seen more than 2 days ago |
| `last-seen:` | `--query "last-seen:<1h"` | Last seen within the last hour |

Filters can be combined: `--query "is:unresolved level:error first-seen:>2d"`

### Resolve Issues

```bash
sentry-cli issues resolve -o <org> -p <project> -i <ID>
```

Bulk resolve issues. Available flags:

- `-i, --id <ID>` — resolve a specific issue by ID
- `-s, --status <STATUS>` — resolve all issues matching a status
- `-a, --all` — resolve all issues
- `-n, --next-release` — only resolve issues in the next release

**SAFETY: This is a bulk operation.** Always use `-i <ID>` to target a single issue unless the user explicitly requests a bulk operation.

### Mute Issues

```bash
sentry-cli issues mute -o <org> -p <project> -i <ID>
```

Bulk mute issues. Available flags:

- `-i, --id <ID>` — mute a specific issue by ID
- `-s, --status <STATUS>` — mute all issues matching a status
- `-a, --all` — mute all issues

**SAFETY: This is a bulk operation.** Always use `-i <ID>` to target a single issue unless the user explicitly requests a bulk operation.

### Unresolve Issues

```bash
sentry-cli issues unresolve -o <org> -p <project> -i <ID>
```

Bulk unresolve issues. Available flags:

- `-i, --id <ID>` — unresolve a specific issue by ID
- `-s, --status <STATUS>` — unresolve all issues matching a status
- `-a, --all` — unresolve all issues

**SAFETY: This is a bulk operation.** Always use `-i <ID>` to target a single issue unless the user explicitly requests a bulk operation.

## Events

### List Events

```bash
sentry-cli events list -o <org> -p <project>
sentry-cli events list -o <org> -p <project> --show-user --show-tags --max-rows 20
```

List project-level events. Available flags:

- `-U, --show-user` — display the Users column
- `-T, --show-tags` — display the Tags column
- `--max-rows <N>` — limit number of rows displayed
- `--pages <N>` — maximum pages to fetch, 100 events/page (default: 5)
