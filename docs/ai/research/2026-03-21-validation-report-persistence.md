---
date: 2026-03-21T18:45:41-07:00
git_commit: 147ad137f6e7493a68fd96cf1b8b2aa9cb5fb359
branch: main
repository: twistedkeg-plugins
topic: "Validation report persistence — existing patterns, integration points, and kb type support"
tags: [research, validation, development-flow, document-lifecycle, kb, thorough-review, compact-plan]
status: complete
last_updated: 2026-03-21
last_updated_by: researcher
---

# Research: Validation Report Persistence

**Date**: 2026-03-21T18:45:41-07:00
**Git Commit**: 147ad137f6e7493a68fd96cf1b8b2aa9cb5fb359
**Branch**: main
**Repository**: twistedkeg-plugins

## Research Question

What existing patterns, integration points, and constraints exist in the codebase for adding persistent validation reports to the development-flow plugin? Specifically: how do other document types (requirements, research, plans) handle file writing, frontmatter, kb import, and cleanup? Where in the validate command and thorough-review plugin should report persistence and discovery be added?

## Summary

The development-flow plugin has a well-established document lifecycle pattern shared by requirements, research, and plans: files are written to `docs/ai/<type>/` with YAML frontmatter, imported into kb with `-t <type>`, and cleaned up during `/compact_plan`. The validate command currently produces output only in the conversation — no files are written and no kb entries are created. The thorough-review command does not search for any development-flow documents (requirements, plans, or validation reports) during its context gathering phase. The kb binary accepts free-form type strings, so `validation` will work without binary changes. The `kb_import_and_cleanup.sh` script passes the type string through unmodified.

## Detailed Findings

### Validate Command — Current Structure

The validate command (`plugins/development-flow/commands/validate.md`) is a read-only analysis command that explicitly states at line 158: "This command does not modify any files — it is read-only analysis."

**Plan resolution** (`validate.md:13-17`): Three-tier fallback — file path from `$ARGUMENTS`, kb document ID, or most recent `.md` in `docs/ai/plans/`.

**Requirements discovery** (`validate.md:21-25`, `skills/validation/references/requirements-discovery.md`): Scans the plan's `## Research documents` section for kb IDs, retrieves each via `kb get`, identifies the requirements document by type or `## Acceptance Criteria` presence. Fallback to `docs/ai/requirements/` file path, then to the plan's own `## Desired End State`.

**Layer execution** (`validate.md:48-124`): Five layers run sequentially, results presented after each. No layer is skipped on prior failure.

**Final report** (`validate.md:126-152`): Console-printed block with per-layer pass/fail and overall verdict. This is the insertion point for file writing — after all layers complete and before the closing instructions.

**Existing kb usage**: Only reads — `kb get <id>` for plan resolution and requirements discovery. No `kb import`, `kb add`, or file write operations anywhere in the command.

**Skill workflow** (`skills/validation/SKILL.md:26-31`): Six steps ending with feedback collection via `skills/improve/references/feedback.md`. Step 4 ("present validation report") and step 5 ("indicate readiness for /commit") are where file writing fits.

### Document Lifecycle Pattern

All three existing document types follow the same pattern:

**File naming**: `docs/ai/<type>/YYYY-MM-DD[-ENG-XXXX]-description.md`

| Type | Directory | Import timing |
|---|---|---|
| Requirements | `docs/ai/requirements/` | End of `/gather_requirements` after user approval |
| Research | `docs/ai/research/` | End of `/research_codebase` after synthesis |
| Plan | `docs/ai/plans/` | During `/compact_plan` after compaction |

**Common frontmatter fields** (requirements and research share these; plans add frontmatter only at compaction):

```yaml
date: [ISO datetime with timezone]
git_commit: [current commit hash]
branch: [current branch]
repository: [repo name]
tags: [type, descriptive-tags]
status: complete
last_updated: [YYYY-MM-DD]
last_updated_by: [who]
```

**Type-specific fields**: Requirements use `feature:`, research uses `topic:`, plans use `compacted:` (added at compaction).

**KB import commands**:
- Requirements: `kb import <file> -t requirements --db kb.db --plain` (`gather_requirements.md:156`)
- Research: `kb import <file> -t research --db kb.db --plain` (`research_codebase.md:184`)
- Plan: via `kb_import_and_cleanup.sh plan <file> [extra files...]` (`compact_plan.md:53`)

**Linking**: After import, related documents are linked via `kb link <new_id> <related_id> -r related --db kb.db --plain`.

**File retention**: Requirements and research files are kept on disk after import — cleanup happens during `/compact_plan`.

### Thorough-Review Context Gathering

The thorough-review command (`plugins/thorough-review/commands/thorough-review.md`) uses a two-tier architecture: the command gathers context and dispatches the `thorough-reviewer` agent.

**Review mode detection** (`thorough-review.md:10-17`): Four detection rules based on `$ARGUMENTS` — plan review (`.md` in plans directory), branch code review (`--branch` or empty), file/directory code review, or ask user.

**Context gathering for code review** (`thorough-review.md:25-30`):
- `git diff main...HEAD --stat` — changed files
- `git log main..HEAD --oneline` — commit list
- `git diff main...HEAD` — full diff
- Project `CLAUDE.md` — conventions

**No external document search**: Neither the command nor the agent searches for requirements, research, plans, or any development-flow artifacts. The context gathering phase (`thorough-review.md:19-30`) consists exclusively of git commands and `CLAUDE.md`. This is the gap where validation report discovery would be inserted.

**Agent dispatch** (`thorough-review.md:31-38`): The command constructs a prompt containing review mode, all gathered inputs, and the contents of `references/output-format.md`. This prompt is the place to include validation report context.

**Agent capabilities** (`agents/thorough-reviewer.md`): The agent has `Read, Grep, Glob, LS, Bash` tools. Bash is restricted to git commands. The agent reads source files during analysis but does not discover external documents on its own.

### Compact Plan Cleanup Mechanism

The compact plan command (`plugins/development-flow/commands/compact_plan.md`) handles cleanup for all document types associated with a plan.

**File discovery** (`compact_plan.md:38-46`): Scans the plan's text content (not filesystem) for:
1. Files in `## Research documents` section
2. References to `docs/ai/research/*.md`
3. References to `docs/ai/requirements/*.md`
4. KB document IDs (`kb:<number>`) — already in kb, but disk files can be deleted
5. Fallback: scan `docs/ai/requirements/` for topic-matching files

Currently only scans for `research` and `requirements` paths. Adding `docs/ai/validations/*.md` scanning would follow the same pattern.

**Safety script** (`scripts/kb_import_and_cleanup.sh`):
- Arguments: `$1` = type, `$2` = file to import, `$3...$N` = extra files to delete
- Sequence: import → extract ID → verify retrieval (≥50 chars) → delete files
- If any step fails, exits non-zero and no files are deleted
- Extra files that don't exist on disk are silently skipped

**Linking** (`compact_plan.md:66-72`): After import, referenced kb IDs are linked with `-r related`.

### KB Binary Type Support

The kb binary accepts **free-form type strings**. Evidence:

- `kb_import_and_cleanup.sh:54` passes `$TYPE` directly to `kb import` with no validation against an allowlist
- The script's only check on type is that it's provided (the `$# -lt 2` check at line 33)
- Documentation in `skills/kb/SKILL.md:7-8` names three types ("research, plan, requirements") but this describes established usage, not enforced constraints
- `kb list` and `kb search` both accept `-t <type>` as a filter

Currently used types: `research`, `plan`, `requirements`. A new `validation` type will work without any changes to the kb binary or the import script.

## Code References

- `plugins/development-flow/commands/validate.md:126-158` — Final report section and read-only statement
- `plugins/development-flow/commands/validate.md:13-17` — Plan path resolution
- `plugins/development-flow/skills/validation/SKILL.md:26-31` — Skill workflow steps
- `plugins/development-flow/skills/validation/references/requirements-discovery.md:1-34` — Requirements discovery process
- `plugins/development-flow/skills/validation/references/validation-layers.md:1-90` — Layer definitions
- `plugins/development-flow/skills/requirements/references/document-template.md:18-28` — Requirements frontmatter template
- `plugins/development-flow/skills/research/references/output-format.md:18-28` — Research frontmatter template
- `plugins/development-flow/skills/planning/references/plan-template.md:3-12` — Plan naming convention
- `plugins/development-flow/commands/gather_requirements.md:150-156` — Requirements kb import
- `plugins/development-flow/commands/research_codebase.md:181-184` — Research kb import
- `plugins/development-flow/commands/compact_plan.md:36-64` — File discovery and cleanup
- `plugins/development-flow/scripts/kb_import_and_cleanup.sh:53-96` — Import verification and deletion
- `plugins/thorough-review/commands/thorough-review.md:19-38` — Context gathering and agent dispatch
- `plugins/thorough-review/agents/thorough-reviewer.md:44-55` — Agent expected context
- `plugins/development-flow/skills/kb/references/cli-commands.md:14-16` — KB type documentation

## Architecture Documentation

### Document Lifecycle Flow

```
Create → Write to docs/ai/<type>/ → Import to kb → Link related docs → Cleanup during /compact_plan
```

All document types follow this same lifecycle. Validation reports will be a fourth type in this pattern, with the difference that import happens immediately after each `/validate` run (like requirements and research) rather than at compaction time (like plans).

### Integration Points for Validation Reports

1. **validate.md** — After the final report block (line 126), add: write report file, import to kb, link to plan. Before layer execution, add: search for prior validation reports for the same plan.
2. **thorough-review.md** — In the context gathering phase (lines 19-30), add: search kb for validation reports matching the current branch/plan.
3. **compact_plan.md** — In the file discovery phase (lines 38-46), add: scan for `docs/ai/validations/*.md` references.
4. **New reference file** — `skills/validation/references/report-template.md` with frontmatter including `plan_path` and `plan_kb_id` fields.

## Related Research

- kb:6 — "Validation step for development-flow plugin — available capabilities and best practices" (research)
- kb:7 — "Validate Command Implementation Plan" (plan)
- kb:13 — "Requirements: Validation Report Persistence" (requirements)

## Open Questions

None.
