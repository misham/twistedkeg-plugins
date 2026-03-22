---
description: Authenticate or re-authenticate with Sentry via sentry-cli
allowed-tools: Bash
---

# Sentry Authentication

Run the sentry-cli authentication flow. This opens a browser for token creation and requires user interaction.

First, verify the binary exists:

```bash
sentry-cli --version
```

If the binary is missing, inform the user that sentry-cli is not installed and point them to https://docs.sentry.io/cli/installation/.

If the binary exists, tell the user to run the login command themselves:

```
! sentry-cli login --global
```

After they complete auth, verify it worked:

```bash
sentry-cli info --no-defaults
```

If the output shows "Authentication Info" with a user and scopes, confirm success. If not, suggest they try again.
