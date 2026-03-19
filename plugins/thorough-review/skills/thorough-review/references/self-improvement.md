# Self-Improvement Workflow

## Overview

The thorough-review plugin uses a two-stage self-improvement loop:

1. **Capture** — After each review, user feedback is saved to `~/.claude/thorough-review.global.yaml` as categorized entries
2. **Promote** — The `/thorough-review-improve` command analyzes accumulated entries, clusters patterns, and proposes promotions into permanent reference files

Promoted patterns directly improve future review behavior through `confidence-rules.md` (scoring adjustments, false positive definitions) and `project-fingerprints.md` (project-type detection rules).

## Data Flow

```
Review completes → capture prompt → user feedback → ~/.claude/thorough-review.global.yaml
                                                              ↓
                                              /thorough-review-improve
                                                              ↓
                                              cluster → propose → approve
                                                              ↓
                                              Edit target reference file
                                              Remove entries from YAML
```

## Reference Files

| File | What it defines |
|---|---|
| `feedback.md` | YAML format, entry fields, categories, capture prompt, Read/Write protocol |
| `analysis-methodology.md` | Clustering methodology, target reference file mapping, content-based target selection |
| `promotion-criteria.md` | When to promote, when not to promote, proposal format, post-promotion cleanup |

## Promotion Targets

Feedback promotes into existing reference files that govern review behavior:

| Target File | What gets promoted there |
|---|---|
| `confidence-rules.md` | False positive definitions, confidence boosters, confidence penalties |
| `project-fingerprints.md` | Project-type detection rules, fingerprint categories |
| `output-format.md` | Structural template changes (rare — only for output format issues) |
