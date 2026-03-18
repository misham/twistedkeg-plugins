# Feedback Capture

## Global Feedback File

**Location:** `~/.claude/development-flow.global.yaml`

**Format:** Pure YAML (no markdown frontmatter). The file is a single YAML document with an `entries` list.

```yaml
entries:
  - skill: requirements
    category: wrong_assumption
    description: "Accepted 'attachments' at face value without disambiguating API entity vs. user mental model"
    project: lnr-cli
    added: "2026-03-15"

  - skill: planning
    category: missing_output
    description: "Plan did not include expected CLI output for the upload phase, so misalignment wasn't caught until implementation"
    project: lnr-cli
    added: "2026-03-15"

  - skill: implementation
    category: what_worked
    description: "TDD cycle caught the API response shape mismatch early in Phase 1"
    project: lnr-cli
    added: "2026-03-16"
```

## Read/Write Protocol

**IMPORTANT:** Always use Read to load the entire file, then Write to replace the entire file. Never use Edit to modify individual entries — YAML indentation is fragile with text-level edits.

- **To add an entry:** Read the file, add the new entry to the `entries` list, Write the complete file back
- **To remove entries:** Read the file, remove the entries from the list, Write the complete file back
- **If the file doesn't exist:** Write a new file with the single entry

## Entry Fields

| Field | Required | Values |
|---|---|---|
| `skill` | Yes | `requirements`, `planning`, `implementation`, `validation`, `research` |
| `category` | Yes | See categories below |
| `description` | Yes | Concise description of what happened |
| `project` | Yes | Repository or project name where the feedback occurred |
| `added` | Yes | ISO date (YYYY-MM-DD) |

## Categories

| Category | When to use |
|---|---|
| `missed_question` | A question should have been asked but wasn't |
| `wrong_assumption` | An assumption was made that turned out to be incorrect |
| `process_issue` | A workflow step was confusing, out of order, or unhelpful |
| `missing_output` | Expected output or examples were not provided |
| `what_worked` | Something went particularly well — preserve this pattern |

## Capture Prompt

At the end of each skill workflow, present:

```
Any feedback on this session? For example:
- Questions I should have asked but didn't
- Assumptions I made that were wrong
- Process steps that were confusing or unhelpful
- Things that worked well

(Type your feedback or "no" to skip)
```

If the user provides feedback:
1. Determine the `category` from the feedback content
2. Read `~/.claude/development-flow.global.yaml` (create if it doesn't exist)
3. Add the new entry to the `entries` list
4. Write the complete updated file

If the user declines (says "no", "skip", "none", etc.), end the skill normally.

## Reading Feedback at Skill Start

Skills do NOT need to read the global feedback file at session start. Unlike thorough-review where accumulated feedback modifies scoring behavior during the review, development-flow feedback is only consumed by the `/improve` command. The disambiguation rules and other skill reference files are the permanent artifacts that encode learned lessons.
