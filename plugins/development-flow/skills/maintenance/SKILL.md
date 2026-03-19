---
name: development-flow-maintenance
description: >
  Plan compaction and kb archival. Use when asked to "compact the plan",
  "archive the plan", "clean up the plan", "import plan to kb",
  "compact and import", or "finalize the plan". Handles compaction of
  finished plans, import into kb database, and cleanup of source files.
  Do NOT use for creating plans or research.
version: 1.0.0
---

# Plan Maintenance

Compact finished or in-progress implementation plans, import into kb database, and clean up source markdown files.

## Compaction

Apply compaction rules to reduce verbosity while preserving information. See `references/compaction-rules.md` for the full ruleset covering what to compact, what to preserve, frontmatter updates, and quality checks.

## KB Import

Use the safety script and link related documents after import. See `references/kb-import-workflow.md` for the full import workflow, requirements file handling, linking rules, and report format.

For general kb CLI reference, see the [KB skill](../kb/SKILL.md).
