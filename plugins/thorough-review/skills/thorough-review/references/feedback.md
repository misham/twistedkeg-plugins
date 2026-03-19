# Feedback Capture

## Global Feedback File

**Location:** `~/.claude/thorough-review.global.yaml`

**Format:** Pure YAML (no markdown frontmatter). The file is a single YAML document with an `entries` list.

```yaml
entries:
  - category: false_positive
    description: "Flagged missing nil check on ActiveRecord .find, but Rails raises RecordNotFound by default"
    project: xpc-api
    added: "2026-03-18"

  - category: missed_pattern
    description: "Did not flag .save without bang in service object — silent failure risk"
    project: xpc-api
    added: "2026-03-18"

  - category: what_worked
    description: "Context triage correctly prioritized API handler over test fixtures in a 15-file changeset"
    project: ppt-compass
    added: "2026-03-18"
```

## Read/Write Protocol

**IMPORTANT:** Always use Read to load the entire file, then Write to replace the entire file. Never use Edit to modify individual entries — YAML indentation is fragile with text-level edits.

- **To add an entry:** Read the file, add the new entry to the `entries` list, Write the complete file back
- **To remove entries:** Read the file, remove the entries from the list, Write the complete file back
- **If the file doesn't exist:** Write a new file with the single entry

## Entry Fields

| Field | Required | Values |
|---|---|---|
| `category` | Yes | See categories below |
| `description` | Yes | Concise description of what happened |
| `project` | Yes | Repository or project name where the feedback occurred |
| `added` | Yes | ISO date (YYYY-MM-DD) |

## Categories

| Category | When to use |
|---|---|
| `false_positive` | A finding was flagged that should not have been |
| `missed_pattern` | An issue was missed that should have been caught |
| `process_issue` | A workflow step was confusing, output was unclear, or context triage failed |
| `what_worked` | Something went particularly well — preserve this pattern |

## Capture Prompt

At the end of each review, present:

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
3. Add the new entry to the `entries` list
4. Write the complete updated file

If the user declines (says "no", "skip", "none", etc.), end normally.

## Reading Feedback at Review Start

The review skill does NOT read the global feedback file at session start. Feedback is only consumed by the `/thorough-review-improve` command. The permanent reference files (`confidence-rules.md`, `project-fingerprints.md`) are the artifacts that encode learned lessons — feedback promotes into them via `/thorough-review-improve`.
