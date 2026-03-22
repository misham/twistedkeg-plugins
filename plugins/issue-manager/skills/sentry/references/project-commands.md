# Project Commands Reference

All commands require `-o <org>` flag.

## Projects

### List Projects

```bash
sentry-cli projects list -o <org>
```

List all projects for an organization. This is the only command that does not require `-p <project>` since it lists all projects.

Only shared flags apply — no project-specific flags beyond `-o <org>`.
