# Requirements Discovery

## Finding the Requirements Document

1. Read the plan file specified by the user
2. Look in the `## Research documents` section for kb document IDs
3. For each kb ID, retrieve the document: `${CLAUDE_PLUGIN_ROOT}/bin/kb get <id> --db kb.db --plain`
4. Identify which document has type `requirements` (or contains `## Acceptance Criteria`)
5. If no requirements doc is found, check for a `docs/ai/requirements/` file referenced in the plan

## Extracting Acceptance Criteria

From the requirements document, extract:

1. **Acceptance Criteria** (`## Acceptance Criteria` section)
   - Each `- [ ]` item is a criterion
   - Format is typically: `Given X, when Y, then Z`
   - These are the items that need evidence

2. **Validation Approach** (`## Validation Approach` section)
   - How the author intended verification to work
   - May specify particular test types or tools

3. **Scope Boundaries** (`## Scope Boundaries` section)
   - `### In Scope` items define what must be validated
   - `### Out of Scope` items should NOT trigger validation concerns

## If No Requirements Document Exists

Some implementations may not have a formal requirements doc (e.g., refactoring, tech debt). In this case:

1. Use the plan's `## Desired End State` as the acceptance criteria source
2. Use the plan's `## Final Manual Verification` items as supplementary criteria
3. Inform the user that no formal requirements doc was found and what was used instead
