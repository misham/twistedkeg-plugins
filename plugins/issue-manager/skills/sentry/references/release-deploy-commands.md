# Release and Deploy Commands Reference

All commands require `-o <org>` and `-p <project>` flags.

## Releases

### List Releases

```bash
sentry-cli releases list -o <org> -p <project>
sentry-cli releases list -o <org> -p <project> --show-projects
sentry-cli releases list -o <org> -p <project> --raw
```

List the most recent releases. Available flags:

- `-P, --show-projects` — display the Projects column
- `-R, --raw` — print raw, delimiter-separated list of releases (defaults to newline)
- `-D, --delimiter <char>` — delimiter for the `--raw` flag

### Release Info

```bash
sentry-cli releases info <VERSION> -o <org> -p <project>
sentry-cli releases info <VERSION> -o <org> -p <project> --show-commits
```

Print information about a specific release. Required argument: `<VERSION>`.

Available flags:

- `-P, --show-projects` — display the Projects column
- `-C, --show-commits` — display the Commits column

### Create Release

```bash
sentry-cli releases new <VERSION> -o <org> -p <project>
sentry-cli releases new <VERSION> -o <org> -p <project> --finalize
```

Create a new release. Required argument: `<VERSION>`.

Available flags:

- `--url <URL>` — optional URL to the release for information purposes
- `--finalize` — immediately finalize the release (mark as released). Combines create and finalize into one step.

### Finalize Release

```bash
sentry-cli releases finalize <VERSION> -o <org> -p <project>
```

Mark a release as finalized and released. Required argument: `<VERSION>`.

Available flags:

- `--url <URL>` — optional URL to the release
- `--released <TIMESTAMP>` — set the release time (defaults to current time)

### Set Release Commits

```bash
sentry-cli releases set-commits <VERSION> --auto -o <org> -p <project>
sentry-cli releases set-commits <VERSION> --local -o <org> -p <project>
```

Associate commits with a release. Required argument: `<VERSION>`.

The `--auto` flag is the most common usage — it automatically discovers commits from the git repository and remotely configured repositories.

Available flags:

- `--auto` — automated commit discovery from git repo (most common)
- `--local` — use local git commits
- `-c, --commit <SPEC>` — manual commit specification (`REPO`, `REPO#PATH`, append `@REV` to override revision)
- `--clear` — remove all commits from the release
- `--ignore-missing` — don't fail if previous release commit not found in repo
- `--initial-depth <N>` — number of commits for initial release (default: 20)

## Deploys

### List Deployments

```bash
sentry-cli deploys list -o <org> -p <project> -r <RELEASE>
```

List all deployments of a release. The `-r <RELEASE>` flag specifies the release slug.

### Create Deployment

```bash
sentry-cli deploys new -o <org> -p <project> -r <RELEASE> -e <ENV>
sentry-cli deploys new -o <org> -p <project> -r <RELEASE> -e production -n "Deploy v1.0" -u "https://example.com"
```

Create a new release deployment. The `-e, --env <ENV>` flag is required (e.g., `production`, `staging`).

Available flags:

- `-e, --env <ENV>` — environment name (required)
- `-r, --release <RELEASE>` — release slug
- `-n, --name <NAME>` — optional human-readable name
- `-u, --url <URL>` — optional URL pointing to the deployment
- `--started <TIMESTAMP>` — optional unix timestamp when deployment started
- `--finished <TIMESTAMP>` — optional unix timestamp when deployment finished
- `-t, --time <SECONDS>` — optional deployment duration in seconds (alternative to `--started`/`--finished`)
