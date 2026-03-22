---
description: Run a thorough, structured code review with source-first analysis
model: opus
argument-hint: "[target: file, directory, --branch, or plan path]"
allowed-tools: Read, Grep, Glob, Bash, Task, Agent
---

Run a thorough code review using the thorough-review skill methodology.

## Step 1: Detect Review Target

Determine the review mode from the argument `$ARGUMENTS`:

- If argument is a file path ending in `.md` inside a plans directory → **plan review**
- If argument is `--branch` or empty and there are uncommitted/branch changes → **code review** of branch diff
- If argument is a file or directory path → **code review** of those specific files
- If ambiguous → ask the user

## Step 2: Gather Inputs

For **plan review:**
- Read the plan file
- Extract all file paths, line numbers, and code claims referenced in the plan

For **code review:**
- Run `git diff main...HEAD --stat` to scope changed files
- Run `git log main..HEAD --oneline` to list commits
- Run `git diff main...HEAD` for the full diff
- Read the project's CLAUDE.md for conventions

## Step 2.5: Discover Validation Context (Code Review Only)

For **code review** mode only, check if prior validation reports exist:

1. Look for the development-flow plugin's `kb` binary: search `~/.claude/plugins/cache/*/development-flow/*/bin/kb` and use the highest version number found. If not found, skip this step silently.
2. If `kb` is available, search for validation reports matching the current branch:
   ```bash
   <kb_path> search "<branch name>" -t validation --db kb.db --plain
   ```
3. If results found, retrieve the most recent report:
   ```bash
   <kb_path> get <id> --db kb.db --plain
   ```
4. Include a summary in the agent dispatch prompt (Step 3):

```
## Prior Validation Context

A validation report exists for this branch (kb #X, YYYY-MM-DD):
- Layer 1 (Tests): [PASS/FAIL]
- Layer 2 (Review): [PASS/FAIL/REVIEW]
- Layer 3 (Coverage): [PASS/FAIL]
- Layer 4 (Acceptance): [PASS/FAIL]
- Layer 5 (Browser): [PASS/FAIL/SKIPPED]
- Overall: [result]
- [Key findings summary]

Use this context to focus on areas that validation flagged or missed.
Do not re-report issues already captured in the validation report unless
you have additional insight.
```

5. If `kb` is not available or no reports found, skip silently — do not error or mention the absence.

## Step 3: Dispatch Reviewer Agent

Launch the `thorough-reviewer` agent (via Task tool) with a prompt containing:
- The review mode (plan or code)
- All inputs gathered above
- The output format from `${CLAUDE_PLUGIN_ROOT}/skills/thorough-review/references/output-format.md`

If `${CLAUDE_PLUGIN_ROOT}` is not set, locate the plugin directory by searching `~/.claude/plugins/` for a directory containing a `thorough-review` plugin.

## Step 4: Present and Capture Feedback

Present the agent's findings to the user. Then offer:
- "Want me to fix the critical/important issues?"

After addressing any fixes, capture feedback following `${CLAUDE_PLUGIN_ROOT}/skills/thorough-review/references/feedback.md`:

Present the capture prompt:
```
Any feedback on this review? For example:
- Findings that should not have been flagged (false positives)
- Issues I missed that should have been caught
- Process problems (output format, context triage, etc.)
- Things that worked well

(Type your feedback or "no" to skip)
```

If the user provides feedback:
1. Determine the `category` from the feedback content
2. Read `~/.claude/thorough-review.global.yaml` (create if it doesn't exist)
3. Add a new entry with `category`, `description`, `project`, and `added` (today's date)
4. Write the complete updated file back (never use Edit on the YAML file)

If the user declines, proceed to the next step.

## Step 5: Offer Gemini Review (Optional)

After presenting findings, also offer:
- "Want a second opinion from Gemini CLI?"

If the user accepts, follow the `gemini-review` skill methodology to launch an independent Gemini review of the same target. Present Gemini's feedback alongside the thorough-review findings, noting where they agree or diverge.
