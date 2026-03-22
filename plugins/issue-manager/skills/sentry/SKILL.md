---
name: issue-manager-sentry
description: >
  This skill should be used when the user asks to "list Sentry issues",
  "search Sentry errors", "resolve Sentry issue", "mute Sentry issue",
  "view Sentry events", "list Sentry projects", "list Sentry releases",
  "create a Sentry release", "finalize release", "set release commits",
  "list deployments", "create deployment", "Sentry issue details",
  "look up Sentry error", "check Sentry", "what errors in Sentry",
  or any interaction with Sentry including error investigation, issue triage,
  release management, and deployment tracking.
  Provides CLI-based Sentry integration via the sentry-cli tool.
  Do NOT use for Linear issues, sprints, or project management — those use
  the issue-manager-linear skill.
version: 0.1.0
---

# Sentry Integration via sentry-cli

Use the `sentry-cli` CLI for error investigation, issue triage, release management, and deployment tracking in Sentry. The `sentry-cli` binary must be installed in your system PATH. The SessionStart hook verifies it is available and authenticated.

**Authentication:** If any command returns an auth error, instruct the user to run `/issue-manager:sentry-login` to re-authenticate.

## Configuration

Sentry configuration is stored at `~/.claude/issue-manager-sentry.local.md` with YAML frontmatter:

```yaml
---
org: <organization-slug>
projects:
  - <project-slug-1>
  - <project-slug-2>
setup_date: <YYYY-MM-DD>
---
```

The `org` field is required and used for all commands. The `projects` list is informational — `sentry-cli projects list` is the authoritative source.

### First-Time Setup

If no config file exists when the user first invokes a Sentry command:

1. Ask the user for their Sentry organization slug
2. Run `sentry-cli projects list -o <org>` to show available projects
3. Save the org and discovered projects to `~/.claude/issue-manager-sentry.local.md`

## Quick Reference

The user must specify a project for every command except `projects list`. Read the org from the config file.

| Operation | Command |
|-----------|---------|
| List issues | `sentry-cli issues list -o <org> -p <project>` |
| List issues by status | `sentry-cli issues list -o <org> -p <project> -s <status>` |
| Search issues | `sentry-cli issues list -o <org> -p <project> --query "<query>"` |
| View specific issue | `sentry-cli issues list -o <org> -p <project> -i <ID>` |
| Limit issue output | `sentry-cli issues list -o <org> -p <project> --max-rows <N>` |
| Resolve issue | `sentry-cli issues resolve -o <org> -p <project> -i <ID>` |
| Mute issue | `sentry-cli issues mute -o <org> -p <project> -i <ID>` |
| Unresolve issue | `sentry-cli issues unresolve -o <org> -p <project> -i <ID>` |
| List events | `sentry-cli events list -o <org> -p <project>` |
| List events with users | `sentry-cli events list -o <org> -p <project> --show-user` |
| List events with tags | `sentry-cli events list -o <org> -p <project> --show-tags` |
| List projects | `sentry-cli projects list -o <org>` |
| List releases | `sentry-cli releases list -o <org> -p <project>` |
| Release info | `sentry-cli releases info <VERSION> -o <org> -p <project>` |
| Create release | `sentry-cli releases new <VERSION> -o <org> -p <project>` |
| Finalize release | `sentry-cli releases finalize <VERSION> -o <org> -p <project>` |
| Set release commits | `sentry-cli releases set-commits <VERSION> --auto -o <org> -p <project>` |
| List deploys | `sentry-cli deploys list -o <org> -p <project> -r <RELEASE>` |
| Create deploy | `sentry-cli deploys new -o <org> -p <project> -r <RELEASE> -e <ENV>` |

## Important Notes

- **Project is always explicit** — the user must specify which project to query. There is no default project.
- **No `--plain` equivalent** — unlike `lnr`, `sentry-cli` outputs human-readable text. Output format may vary across versions.
- **Default to `--max-rows 20`** for list commands to avoid overwhelming output. Use filters (`-s`, `--query`) to narrow results.
- **Status values** for issues: `resolved`, `muted`, `unresolved`.

## Safety: Bulk Operations

`issues resolve`, `issues mute`, and `issues unresolve` are **bulk operations** by default. They act on ALL matching issues unless constrained.

- **NEVER** run these commands without `-i <ID>` unless the user explicitly requests a bulk operation.
- **Always confirm** with the user before executing any bulk operation without `-i`.
- To act on a single issue, always include `-i <ID>`.

## Common Workflows

### Error investigation

1. List recent unresolved issues: `sentry-cli issues list -o <org> -p <project> -s unresolved --max-rows 20`
2. View events for a project: `sentry-cli events list -o <org> -p <project> --show-user --max-rows 20`
3. Search for specific errors: `sentry-cli issues list -o <org> -p <project> --query "is:unresolved level:error"`
4. Resolve investigated issue: `sentry-cli issues resolve -o <org> -p <project> -i <ID>`

### Release management

1. List recent releases: `sentry-cli releases list -o <org> -p <project>`
2. Create a new release: `sentry-cli releases new <VERSION> -o <org> -p <project>`
3. Associate commits: `sentry-cli releases set-commits <VERSION> --auto -o <org> -p <project>`
4. Finalize the release: `sentry-cli releases finalize <VERSION> -o <org> -p <project>`
5. View release details: `sentry-cli releases info <VERSION> -o <org> -p <project> --show-commits`

### Deployment tracking

1. Create a deploy: `sentry-cli deploys new -o <org> -p <project> -r <RELEASE> -e production`
2. List deploys for a release: `sentry-cli deploys list -o <org> -p <project> -r <RELEASE>`

## Error Handling

- **Auth errors:** Suggest `/issue-manager:sentry-login` for re-authentication
- **Missing config:** Run the first-time setup flow (ask for org, list projects, save config)
- **Missing binary:** Point to https://docs.sentry.io/cli/installation/
- **Org/project not found:** Run `sentry-cli projects list -o <org>` to verify available projects

## Detailed References

- [Issue and Event Commands](references/issue-event-commands.md) — issue list/resolve/mute/unresolve and event list
- [Release and Deploy Commands](references/release-deploy-commands.md) — release management and deployment tracking
- [Project Commands](references/project-commands.md) — project listing
