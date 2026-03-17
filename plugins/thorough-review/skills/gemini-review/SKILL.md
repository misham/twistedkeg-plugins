---
name: gemini-review
description: >
  Independent Gemini CLI review for a second opinion from a different model
  family. Use when asked for a "Gemini review", "second opinion", "independent
  review", or "cross-model review". Requires Gemini CLI to be installed. Do NOT
  use as a standalone review — this supplements the thorough-review methodology.
version: 1.0.0
---

# Gemini Review

Shell out to Google Gemini CLI to get an independent review — a second pair of eyes from a different model family. Gemini has full disk read access in plan mode; pass it file paths and let it do the reading.

## Prerequisites

Verify Gemini CLI is installed before proceeding:

```bash
gemini --version 2>/dev/null
```

If this fails:
- Warn the user: "Gemini CLI is not installed. Install it from https://github.com/google-gemini/gemini-cli — skipping Gemini review."
- Stop. Do not proceed.

Authentication is verified implicitly when launching. If it fails with an auth error, tell the user to run `gemini` interactively to complete OAuth setup.

## Determine the Review Target

Use the target provided by the calling command or the user. Infer from context if needed:

| Signal | Target |
|--------|--------|
| Explicit file/dir/branch path | That target |
| "review the plan" or no target | Most recent plan in `docs/ai/plans/` |
| "review the branch" / "review the diff" | Branch diff against base (use `git merge-base HEAD main`) |
| Mid-conversation "review this" | Current work — summarize task + relevant file paths |

Find the most recent plan:
```bash
plan=$(find docs/ai/plans -maxdepth 1 -name '*.md' -print0 2>/dev/null | xargs -0 ls -t 2>/dev/null | head -1)
```

## Build the Prompt

Keep it short. Gemini shares no context with Claude Code — the prompt must be self-contained with file paths and a clear ask, not inlined content.

**Use these prompts verbatim** (substituting only bracketed placeholders):

Plan review:
```
Read the plan outlined in <absolute path to plan file> and provide structured, actionable feedback for improvement.
```

Code/diff review:
```
Review the changes on this branch against <base-branch>. Provide structured, actionable feedback.
```

General review:
```
Read <file paths> and <what you want reviewed>. Provide structured, actionable feedback.
```

If the target needs context, add one sentence of project description. Nothing more.

## Launch Gemini

Create a temp directory for output, then launch:

```bash
review_dir=$(mktemp -d /tmp/gemini-review-XXXXXX)
output_file="$review_dir/review.md"
debug_log="$review_dir/debug.log"

(cd <working-directory> && gemini -p "<prompt>" --approval-mode plan -o text) >"$output_file" 2>"$debug_log"
```

Use a Bash timeout of at least 300000ms (5 minutes).

**Flags:**
- `cd <dir>` — working directory via subshell
- `--approval-mode plan` — read-only; Gemini can read but not write
- `-o text` — plain text output format
- stdout → output file, stderr → debug log

**On failure:** Read the debug log and surface a summary to the user. Do not proceed.

### Follow-Up Reviews

Resume the latest session for follow-ups:

```bash
(cd <working-directory> && gemini --resume latest -p "<follow-up prompt>" --approval-mode plan -o text) >"$output_file" 2>"$debug_log"
```

Follow-up prompts:
- Re-review: `Re-review the plan/code against the feedback you gave previously. Note what has been addressed, what remains, and any new concerns.`
- Targeted: `<specific question or area to focus on, referencing prior feedback>`

## Present Feedback

Read the output file. Present all feedback to the user — do not silently incorporate or skip. For each piece:

1. Summarize it clearly
2. Let the user decide whether to accept, modify, or skip
3. Discuss before acting if needed

## Troubleshooting

- **Gemini fails to start:** Check `gemini --version`, read debug log, verify flags against `gemini --help`
- **Empty output:** Check debug log — may be timeout or error. Try smaller scope.
- **Auth errors:** User needs to run `gemini` interactively for OAuth setup.
- **`--resume` fails:** Session may have expired. Start fresh. Use `gemini --list-sessions` to check.
- **Timeout:** Increase Bash timeout (max 600000ms) or review smaller scope.
