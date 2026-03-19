# thorough-review

Source-first, verification-oriented code review with self-improving feedback loops.

## What It Does

This plugin implements a structured code review methodology based on three principles:

1. **Source-first** — read full source files for context, not just diffs
2. **Verification-oriented** — verify specific claims against actual code
3. **Concrete fixes** — every finding includes a specific remediation

It supports two review modes: **code review** (branch diffs, specific files) and **plan review** (implementation plans with verification tables).

All findings are confidence-scored (0-100) with only findings >= 75 reported, reducing noise and false positives.

## Usage

### `/thorough-review`

Run a thorough code review. Accepts a target argument:

```
/thorough-review --branch          # Review branch changes against main
/thorough-review src/api/          # Review specific directory
/thorough-review path/to/plan.md   # Review a plan document
/thorough-review                   # Auto-detect from context
```

### `/thorough-review-improve`

Promote accumulated feedback patterns into permanent rules:

```
/thorough-review-improve
```

This command reads feedback from `~/.claude/thorough-review.global.yaml`, clusters patterns, and proposes promotions into permanent reference files (`confidence-rules.md`, `project-fingerprints.md`).

## Self-Improvement Loop

After each review, the plugin captures feedback into `~/.claude/thorough-review.global.yaml` with four categories:
- **false_positive** — findings that were wrong get recorded to prevent recurrence
- **missed_pattern** — things the review should have caught get added as boosters
- **process_issue** — workflow or output format problems
- **what_worked** — positive patterns to preserve

Use `/thorough-review-improve` to promote stable patterns into permanent reference files.

## Interaction with Other Tools

| Tool | Relationship |
|------|-------------|
| `code-review` plugin | Posts to GitHub PRs. This plugin does local reviews. Complementary. |
| `pr-review-toolkit` plugin | Different trigger phrases. No conflict. |
| `/gemini_review` | Cross-model validation. Can be used after this plugin for a second opinion. |
