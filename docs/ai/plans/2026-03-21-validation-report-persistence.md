# Validation Report Persistence Implementation Plan

## Research documents

- kb #13: "Requirements: Validation Report Persistence" (requirements)
- kb #14: "Validation report persistence — existing patterns, integration points, and kb type support" (research)
- kb #7: "Validate Command Implementation Plan" (plan — original validate command design)
- kb #6: "Validation step for development-flow plugin — available capabilities and best practices" (research)

## Overview

Add persistent validation report documents to the development-flow plugin. Each `/validate` run writes a report to `docs/ai/validations/`, imports it to kb as type `validation`, and discovers prior reports for the same plan. The thorough-review command gains validation report discovery for additional context. The compact_plan command gains cleanup of validation report files.

## Current State Analysis

The validate command (`plugins/development-flow/commands/validate.md`) runs 5 validation layers and presents a final report as conversation-only output. At line 158 it explicitly states: "This command does not modify any files — it is read-only analysis." No files are written and no kb entries are created.

The thorough-review command (`plugins/thorough-review/commands/thorough-review.md:19-30`) gathers context exclusively from git commands and project `CLAUDE.md`. It does not search for any development-flow documents.

The compact_plan command (`plugins/development-flow/commands/compact_plan.md:38-46`) scans plan text for `docs/ai/research/*.md` and `docs/ai/requirements/*.md` references but has no awareness of a `docs/ai/validations/` directory.

The kb binary accepts free-form type strings — `validation` will work without binary changes.

### Key Discoveries:
- Validate command's final report is at `validate.md:126-152` — insertion point for file writing
- Prior report discovery goes before layer execution, after requirements discovery (`validate.md:25`)
- Thorough-review context gathering is at `thorough-review.md:19-30` — insertion point for validation report discovery
- Compact plan file scanning is at `compact_plan.md:38-46` — insertion point for validations path
- Requirements and research use direct `kb import`; plans use the safety script. Validation reports should use direct `kb import` (like requirements/research) since they're imported immediately, not during compaction
- The `kb_import_and_cleanup.sh` script needs no changes — compact_plan already passes extra files for deletion

## Desired End State

After implementation:

1. Each `/validate` run produces a markdown file in `docs/ai/validations/` with YAML frontmatter (including `plan_path` and `plan_kb_id`) and structured layer results, imported to kb as type `validation`
2. Subsequent `/validate` runs discover prior reports for the same plan and reference them in the output
3. `/thorough-review` discovers validation reports for the current branch/plan and includes them as context
4. `/compact_plan` discovers and cleans up `docs/ai/validations/*.md` files

**Verification**: Run `/validate` twice on a plan, confirm the second run references the first. Run `/thorough-review` and confirm it discovers the validation report. Run `/compact_plan` and confirm validation files are cleaned up.

## What We're NOT Doing

- Changing what the 5 validation layers check
- Adding new validation layers
- Changing the thorough-review methodology (only adding context input)
- Generating validation reports retroactively
- Using the safety script for validation imports (direct `kb import` is sufficient since we import immediately, not during compaction)
- Adding validation report update-in-place (each run creates a new document)

## Implementation Approach

Follow the existing document lifecycle pattern exactly. Create a report template reference file mirroring the structure of `document-template.md` and `output-format.md`. Modify the validate command to write a report after presenting the final report, import it to kb, and discover prior reports before running layers. Add a kb search step to the thorough-review command. Extend compact_plan's file scanning to include `docs/ai/validations/*.md`.

---

## Phase 1: Report Template & Write Logic ✅ COMPLETE

### Overview
Create the validation report template reference file and add file writing + kb import to the validate command. This is the core change — after this phase, validation reports are persisted.

### Changes Required:

#### 1. New Report Template Reference
**File**: `plugins/development-flow/skills/validation/references/report-template.md` (new)
**Changes**: Create a report template following the pattern of `skills/requirements/references/document-template.md` and `skills/research/references/output-format.md`.

The template defines:
- **File naming**: `docs/ai/validations/YYYY-MM-DD[-ENG-XXXX]-description.md` (same convention as other types)
- **Frontmatter fields**:
  - Common fields: `date`, `git_commit`, `branch`, `repository`, `tags`, `status`, `last_updated`, `last_updated_by`
  - Type-specific fields: `plan_path` (file path to the plan), `plan_kb_id` (kb document ID of the plan, if known), `plan_title` (human-readable plan name)
  - Validation-specific field: `overall_result` (ALL_PASS, ISSUES_FOUND)
- **Body structure**: Plan reference, requirements source, per-layer results (preserving the existing output format from `validate.md:57-124`), acceptance criteria traceability table, overall verdict

#### 2. Update Validate Command — Report Writing
**File**: `plugins/development-flow/commands/validate.md`
**Changes**:

a. Add kb tool documentation to the command's available tools section. Add `Write` to the implicit tool set (the command has no `allowed-tools` frontmatter, so all tools are available — no frontmatter change needed).

b. After the "Final Report" section (after line 152), add a new section "## Report Persistence" with steps:
  1. Gather metadata via `${CLAUDE_PLUGIN_ROOT}/scripts/spec_metadata.sh`
  2. Create `docs/ai/validations/` directory (`mkdir -p`)
  3. Write the report file using the template from `references/report-template.md`
  4. Import to kb: `${CLAUDE_PLUGIN_ROOT}/bin/kb import docs/ai/validations/<filename>.md -t validation --db kb.db --plain`
  5. If the plan was resolved from a kb ID, link: `${CLAUDE_PLUGIN_ROOT}/bin/kb link <report_id> <plan_kb_id> -r related --db kb.db --plain`
  6. Present the report file path and kb ID to the user

c. Remove the statement at line 158 ("This command does not modify any files — it is read-only analysis") since it will no longer be true.

#### 3. Update Validation Skill
**File**: `plugins/development-flow/skills/validation/SKILL.md`
**Changes**: Add step between current steps 4 and 5: "Write validation report to `docs/ai/validations/` and import to kb (see `references/report-template.md`)". Update the Key Rules section to note that the report captures all layer results.

### Success Criteria:
- [ ] `plugins/development-flow/skills/validation/references/report-template.md` exists with frontmatter template and body structure
- [ ] Template includes `plan_path`, `plan_kb_id`, and `plan_title` fields in frontmatter
- [ ] Template includes `overall_result` field in frontmatter
- [ ] `validate.md` contains a "Report Persistence" section after the Final Report section
- [ ] `validate.md` references `report-template.md` for the report structure
- [ ] `validate.md` includes `kb import` command with `-t validation`
- [ ] `validate.md` includes `kb link` command for plan linkage
- [ ] `validate.md` no longer claims to be read-only
- [ ] `SKILL.md` includes report writing step in workflow

---

## Phase 2: Prior Report Discovery ✅ COMPLETE

### Overview
Add discovery of prior validation reports to the validate command so subsequent runs can reference what was found previously.

### Changes Required:

#### 1. Update Validate Command — Prior Report Discovery
**File**: `plugins/development-flow/commands/validate.md`
**Changes**:

After step 3 (requirements discovery, lines 21-25) and before step 4 (presenting discovered requirements), add a new step "Discover prior validation reports":

1. If the plan was resolved from a kb ID, use `kb link` to find related validation reports: `${CLAUDE_PLUGIN_ROOT}/bin/kb links <plan_kb_id> --db kb.db --plain` and filter for type `validation`
2. Also search kb by plan title as a fallback: `${CLAUDE_PLUGIN_ROOT}/bin/kb search "<plan title>" -t validation --db kb.db --plain`
3. Also scan `docs/ai/validations/` for files with matching `plan_path` or `plan_kb_id` in frontmatter (most reliable — catches reports not yet linked or with title mismatches)
4. Deduplicate results across all three discovery methods
5. If prior reports found, retrieve the most recent one via `kb get <id>` and extract:
   - Which layers had issues
   - Which acceptance criteria failed
   - The overall result
4. Present prior report context alongside the requirements discovery output:

```
Prior validation reports found: [N]
Most recent (kb #X, YYYY-MM-DD):
  - Overall: [ISSUES_FOUND/ALL_PASS]
  - Issues: [brief summary of failed layers/criteria]

This run will check whether previously identified issues have been resolved.
```

5. After all layers complete, in the Final Report section, add a "Changes from prior run" comparison if a prior report exists:
   - Issues resolved (were FAIL, now PASS)
   - Issues persisting (still FAIL)
   - New issues (were PASS or not checked, now FAIL)

### Success Criteria:
- [ ] `validate.md` includes a "Discover prior validation reports" step after requirements discovery
- [ ] The step uses `kb links` when plan kb ID is known, `kb search` as fallback, and filesystem scan of `docs/ai/validations/` as most reliable method
- [ ] Results are deduplicated across all three discovery methods
- [ ] Prior report summary is presented before layer execution
- [ ] Final report includes "Changes from prior run" comparison when prior reports exist
- [ ] When no prior reports exist, the step is silently skipped (no error, no message)

---

## Phase 3: Thorough-Review Integration ✅ COMPLETE

### Overview
Add validation report discovery to the thorough-review command so it can use prior validation findings as context.

### Changes Required:

#### 1. Update Thorough-Review Command
**File**: `plugins/thorough-review/commands/thorough-review.md`
**Changes**:

In the context gathering phase (after line 30, where `CLAUDE.md` is read), add a new step for code review mode only (not plan review mode):

1. Check if the kb binary exists at the development-flow plugin path (it may not be installed): look for `kb` binary in `~/.claude/plugins/*/development-flow/*/bin/kb` or the cached plugin path
2. If kb is available, search for validation reports: `<kb_path> search "<branch name>" -t validation --db kb.db --plain`
3. If results found, retrieve the most recent report via `<kb_path> get <id> --db kb.db --plain`
4. Include a summary in the agent dispatch prompt:

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

5. If kb is not available or no reports found, skip silently

### Success Criteria:
- [ ] `thorough-review.md` includes validation report discovery step in code review context gathering
- [ ] Discovery gracefully handles missing kb binary (skip silently)
- [ ] Discovery gracefully handles no validation reports found (skip silently)
- [ ] The agent dispatch prompt includes validation context when available
- [ ] Validation context instructs the agent to avoid duplicating known findings

---

## Phase 4: Compact Plan Cleanup ✅ COMPLETE

### Overview
Extend compact_plan to discover and clean up `docs/ai/validations/*.md` files associated with the plan being compacted.

### Changes Required:

#### 1. Update Compact Plan Command
**File**: `plugins/development-flow/commands/compact_plan.md`
**Changes**:

In Step 3 "Identify Related Documents to Clean Up" (lines 38-46), after the existing checks for research and requirements files, add:

```
6. Look for references to `docs/ai/validations/*.md` files
7. Search kb for validation reports linked to this plan: `${CLAUDE_PLUGIN_ROOT}/bin/kb search "<plan title>" -t validation --db kb.db --plain`
8. For any validation reports found in kb, check if corresponding files exist in `docs/ai/validations/`
```

Add `docs/ai/validations/*.md` to the collected file paths passed to the cleanup script.

In Step 4, the existing `kb_import_and_cleanup.sh` call already handles extra files for deletion — validation report files are passed as additional arguments alongside research and requirements files. Since validation reports are already imported to kb during `/validate`, they are included here only for file cleanup (same as requirements files).

Add a note mirroring the existing one about requirements: "Validation report files are already imported into kb during `/validate`. They are included here only for file cleanup."

#### 2. Update Maintenance References
**File**: `plugins/development-flow/skills/maintenance/references/kb-import-workflow.md`
**Changes**: This file explicitly mentions `docs/ai/requirements/*.md` (line 14) and shows usage examples with `[research_files...] [requirements_files...]` (line 8). Update both to include validation files: add `[validation_files...]` to the usage example and add `docs/ai/validations/*.md` alongside the requirements reference.

**File**: `plugins/development-flow/skills/maintenance/SKILL.md`
**Changes**: If this file mentions specific cleanup directories, add `docs/ai/validations/` to the list.

#### 3. Acknowledge Cross-Plugin Dependency (Phase 3)
Note: Phase 3 introduces a new dependency direction — thorough-review optionally discovers development-flow's kb binary. Currently the dependency runs only one way (development-flow invokes thorough-review in Layer 2). This is acceptable because the discovery degrades gracefully (skip silently if kb binary is missing or no reports found), making it a purely additive enhancement with no coupling risk.

### Success Criteria:
- [ ] `compact_plan.md` Step 3 includes scanning for `docs/ai/validations/*.md` files
- [ ] `compact_plan.md` Step 3 includes kb search for validation reports linked to the plan
- [ ] Validation report files are passed as extra arguments to `kb_import_and_cleanup.sh`
- [ ] A note clarifies that validation files are already in kb and included only for file cleanup
- [ ] `kb-import-workflow.md` usage example includes validation files
- [ ] `kb-import-workflow.md` requirements file reference updated to include validation files

---

## Final Manual Verification

_Run once after all phases are complete and all automated checks pass._

- [ ] Run `/validate` on a test plan — verify a report file is created in `docs/ai/validations/` with correct frontmatter (including `plan_path`, `plan_kb_id`, `overall_result`)
- [ ] Verify kb import with `kb get <id>` — content matches the file
- [ ] Run `/validate` a second time on the same plan — verify the second run discovers and references the first report, and the "Changes from prior run" comparison appears
- [ ] Run `/thorough-review --branch` — verify it discovers the validation report and includes it as context in the agent prompt
- [ ] Verify `/thorough-review` handles missing kb binary gracefully (no errors)
- [ ] Review `compact_plan.md` to confirm `docs/ai/validations/*.md` is included in the cleanup scan

---

## Testing Strategy

### Unit Tests:
- Not applicable — this is a pure-markdown plugin with no executable code to unit test

### Integration Tests:
- Not applicable — plugin behavior is validated through manual execution of commands

### Manual Testing Steps:
1. Run `/validate` on a plan and verify the report file appears in `docs/ai/validations/`
2. Check the report file has correct YAML frontmatter and structured layer results
3. Run `kb get <id>` to verify the kb import worked
4. Run `/validate` again and verify prior report discovery and comparison
5. Run `/thorough-review --branch` and verify validation context appears
6. Review compact_plan changes for correctness

## Performance Considerations

None — the additional kb search and file write operations are negligible overhead relative to the validation layers themselves (which run tests, linters, and the thorough-review agent).

## Migration Notes

No migration needed. Existing plans validated before this feature will simply have no validation reports to discover — all discovery steps handle the "no reports found" case silently.

## References

- Related requirements: kb #13, `docs/ai/requirements/2026-03-21-validation-report-persistence.md`
- Related research: kb #14, `docs/ai/research/2026-03-21-validation-report-persistence.md`
- Original validate plan: kb #7
- Validation capabilities research: kb #6
- Pattern reference — requirements template: `plugins/development-flow/skills/requirements/references/document-template.md`
- Pattern reference — research output format: `plugins/development-flow/skills/research/references/output-format.md`
- Pattern reference — compact plan cleanup: `plugins/development-flow/commands/compact_plan.md:36-64`
