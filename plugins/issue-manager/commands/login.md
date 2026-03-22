---
description: Authenticate or re-authenticate with Linear via lnr CLI
allowed-tools: Bash
---

# Linear Authentication

Run the lnr authentication flow. This opens a browser for OAuth login and requires user interaction.

First, verify the binary exists:

```bash
lnr --version
```

If the binary is missing, inform the user that lnr is not installed and point them to https://github.com/misham/lnr/releases.

If the binary exists, tell the user to run the login command themselves:

```
! lnr auth login
```

After they complete auth, verify it worked:

```bash
lnr auth status
```

If auth status shows authenticated, confirm success. If not, suggest they try again.
