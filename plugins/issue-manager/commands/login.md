---
description: Authenticate or re-authenticate with Linear via lnr CLI
allowed-tools: Bash
---

# Linear Authentication

Run the lnr authentication flow. This opens a browser for OAuth login and requires user interaction.

First, verify the binary exists:

```bash
${CLAUDE_PLUGIN_ROOT}/bin/lnr --version
```

If the binary is missing, inform the user that the install hook may not have run and suggest restarting the session.

If the binary exists, resolve the absolute path and tell the user to run the login command themselves. Present the concrete path (not the `${CLAUDE_PLUGIN_ROOT}` variable, which is not available in the user's shell):

```
! /resolved/absolute/path/to/bin/lnr auth login
```

After they complete auth, verify it worked:

```bash
${CLAUDE_PLUGIN_ROOT}/bin/lnr auth status
```

If auth status shows authenticated, confirm success. If not, suggest they try again.
