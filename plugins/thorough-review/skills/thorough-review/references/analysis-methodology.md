# Analysis Methodology

## Clustering

Cluster entries from `~/.claude/thorough-review.global.yaml` by similarity:
- Same `category` AND overlapping keywords in `description` → likely the same pattern
- Entries from different projects about the same issue → stronger signal

## Pattern Identification

For each cluster, determine:
1. **What went wrong (or right)** — distill the cluster into a single actionable statement
2. **Which reference file to target** — map the pattern to the specific reference file it should modify
3. **What the edit would look like** — draft the specific text to add or modify

## Target Reference File Mapping

| Category | Target File | Target Section |
|---|---|---|
| `false_positive` | `references/confidence-rules.md` | False Positive Definitions list |
| `missed_pattern` | `references/confidence-rules.md` | Confidence Boosters table |
| `process_issue` | Determined by content | See selection rules below |
| `what_worked` | Determined by content | See selection rules below |

### Target Selection for `process_issue`

- Scoring-related feedback (e.g., "confidence too high/low", "wrong severity") → `references/confidence-rules.md` Confidence Penalties table
- Review methodology feedback (e.g., "didn't read enough context", "context triage missed files") → `references/confidence-rules.md` Confidence Penalties table
- Output format feedback (e.g., "findings were hard to read", "missing section") → `references/output-format.md` templates (only for structural template changes, not individual rule entries)

### Target Selection for `what_worked`

- Scoring accuracy feedback (e.g., "confidence was right on this pattern") → `references/confidence-rules.md` Confidence Boosters table
- Project-type-specific feedback (e.g., "fingerprinting caught the Rails convention") → `references/project-fingerprints.md` Fingerprint Categories table or Process steps

When the target is ambiguous, default to `references/confidence-rules.md` and let the reviewer use judgment during `/thorough-review-improve`.

## Handling "what_worked" Entries

Positive feedback ("what_worked" category) should be treated differently:
- If it confirms an existing rule, note it but don't propose changes (the rule is already working)
- If it describes a pattern NOT in any reference file, propose adding it as a rule to preserve the behavior
