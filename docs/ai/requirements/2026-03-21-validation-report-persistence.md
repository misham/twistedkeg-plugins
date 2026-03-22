---
date: 2026-03-21T18:06:33-07:00
git_commit: 147ad137f6e7493a68fd96cf1b8b2aa9cb5fb359
branch: main
repository: twistedkeg-plugins
feature: "Validation Report Persistence"
tags: [requirements, validation, development-flow, kb, report-persistence]
status: complete
last_updated: 2026-03-21
last_updated_by: user
---

# Requirements: Validation Report Persistence

## Problem Statement

The `/validate` command runs 5 validation layers (tests & static analysis, thorough review, test coverage, acceptance criteria tracing, browser validation) but only displays results in the conversation. Subsequent `/validate` and `/thorough-review` runs start from scratch with no knowledge of prior findings, leading to duplicated effort and no progression tracking.

## Motivation & Value

Enables iterative validation where each run builds on the previous. Reviewers and validators can focus on whether previously identified issues were fixed rather than re-discovering them. Aligns the validation output with the existing document lifecycle pattern used by requirements, research, and plans.

## User Context

A developer using the development-flow plugin, running `/validate` and `/thorough-review` iteratively during steps 7-11 of the global development flow. They may run validation multiple times as they fix issues, and run a final thorough-review that should be aware of what validation already checked.

## Desired Behavior

After each `/validate` run completes, a validation report markdown file is written to `docs/ai/validations/` and imported into kb as type `validation`. The report captures all 5 layer results, acceptance criteria tracing, and the overall pass/fail status.

When `/validate` runs again for the same plan, it discovers prior validation reports (via kb search and/or file scan) and references them — noting which issues were previously found so the user can see progression.

When `/thorough-review` runs, it searches for existing validation reports relevant to the current branch/plan and uses them as additional context for its analysis.

When `/compact_plan` runs, it discovers and cleans up associated `docs/ai/validations/*.md` files alongside research and requirements files.

## Scope Boundaries

### In Scope
- Validation command writes a report file to `docs/ai/validations/` with proper frontmatter
- Report imported into kb as type `validation`
- Subsequent `/validate` runs discover and reference prior validation reports for the same plan
- `/thorough-review` discovers and references validation reports as context
- `/compact_plan` cleans up validation report files
- Validation report document template (new reference file)
- Report references plan via both kb ID and file path in frontmatter

### Out of Scope
- Changing what the 5 validation layers check
- Adding new validation layers
- Changing the thorough-review methodology (only adding context discovery)
- Generating validation reports retroactively for plans that were validated before this feature

## Considered Approaches

### Selected: Follow Existing Document Lifecycle Pattern

Each validation run produces a new markdown document in `docs/ai/validations/`, following the same naming convention and frontmatter pattern as requirements/research/plans. Documents are imported into kb as type `validation`. Later runs query kb and scan the directory for prior reports linked to the same plan. Reports store both the plan file path and plan kb ID (when available) in frontmatter for durability across compaction.

### Alternatives Considered

**Update-in-Place**
- How it works: Overwrite the same validation report each run, appending a history section
- Trade-offs: Simpler file management, but loses the ability to see each run as a distinct snapshot
- Why not chosen: Progression tracking requires seeing prior states independently; a single document with appended history gets unwieldy after multiple runs

**Conversation-Only with Summary**
- How it works: Output structured results in conversation only, with no file persistence
- Trade-offs: Zero file overhead, but no cross-session or cross-command visibility
- Why not chosen: Downstream commands (`/thorough-review`, subsequent `/validate`) cannot reference conversation-only output

## Acceptance Criteria

- [ ] Given a `/validate` run completes, when the final report is presented, then a markdown file is also written to `docs/ai/validations/` with proper frontmatter and imported to kb as type `validation`
- [ ] Given a prior validation report exists for the same plan, when `/validate` runs again, then it discovers and references the prior report(s) in its output
- [ ] Given a validation report exists in kb, when `/thorough-review` runs, then it searches for and references relevant validation reports as context
- [ ] Given a completed plan with validation reports, when `/compact_plan` runs, then it discovers and cleans up associated `docs/ai/validations/*.md` files
- [ ] Given a validation report is written, when the report file is inspected, then it contains both the plan file path and plan kb ID (when available) in frontmatter

## Validation Approach

- Run `/validate` on a test plan and verify a report file is created in `docs/ai/validations/` with correct frontmatter and content
- Verify kb import with `kb get <id>` after a validation run
- Run `/validate` a second time on the same plan and verify the second run references findings from the first
- Run `/thorough-review` after `/validate` and verify it discovers and uses the validation report as context
- Run `/compact_plan` and verify validation report files are cleaned up

## Constraints & Assumptions

- The kb binary supports importing documents with type `validation` (or the type is flexible/user-defined — needs verification during research)
- The validation report template must capture enough structured data for downstream consumers to parse (layer results, acceptance criteria table, plan references)
- The existing `kb_import_and_cleanup.sh` script may need to handle the new `docs/ai/validations/` path in its cleanup logic

## Key Deliverables

- Validation report document template (`skills/validation/references/report-template.md`) including plan file path and kb ID in frontmatter
- Updated `validate.md` command to write reports, import to kb, and discover prior reports
- Updated validation skill and references as needed
- Updated `thorough-review` command or agent to discover validation reports
- Updated `compact_plan.md` command to clean up `docs/ai/validations/*.md` files

## Open Questions

(none)
