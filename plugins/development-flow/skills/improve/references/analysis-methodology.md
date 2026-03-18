# Analysis Methodology

## Grouping

Group entries from `~/.claude/development-flow.global.yaml` by `skill` field:
- All `requirements` entries together
- All `planning` entries together
- etc.

Within each skill group, cluster entries by similarity:
- Same `category` AND overlapping keywords in `description` → likely the same pattern
- Entries from different projects about the same issue → stronger signal

## Pattern Identification

For each cluster, determine:
1. **What went wrong (or right)** — distill the cluster into a single actionable statement
2. **Which reference file to target** — map the pattern to the specific skill reference file it should modify
3. **What the edit would look like** — draft the specific text to add or modify

## Target Reference File Mapping

| Skill | Existing Reference Files | What they govern |
|---|---|---|
| requirements | `references/conversation-techniques.md` | Question sequence and elicitation rules |
| requirements | `references/document-template.md` | Output document structure |
| requirements | `references/review-criteria.md` | Automated review checks |
| requirements | `references/disambiguation-rules.md` | API entity and write destination rules |
| planning | `references/plan-template.md` | Plan document structure |
| planning | `references/research-integration.md` | How research feeds into planning |
| planning | `references/disambiguation-rules.md` | API entity verification and output examples |
| implementation | `references/tdd-cycle.md` | Red/green/refactor protocol |
| implementation | `references/phase-gates.md` | Phase completion and gate protocol |
| validation | `references/validation-layers.md` | Validation layer definitions |
| validation | `references/requirements-discovery.md` | How to find linked requirements |
| research | `references/agent-dispatch.md` | Sub-agent selection and dispatch |
| research | `references/output-format.md` | Research document structure |

If no existing reference file is a natural fit, propose creating a new reference file under the appropriate skill's `references/` directory.

## Handling "what_worked" Entries

Positive feedback ("what_worked" category) should be treated differently:
- If it confirms an existing rule, note it but don't propose changes (the rule is already working)
- If it describes a pattern NOT in any reference file, propose adding it as a rule to preserve the behavior
