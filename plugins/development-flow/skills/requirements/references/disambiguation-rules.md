# Disambiguation Rules

## API Entity Name Disambiguation

When the user mentions a noun that could map to a specific API entity (e.g., "attachment", "comment", "label", "project"), present the distinction:

"In [platform]'s API, [term] refers to [specific API entity description]. Is that what you mean, or do you mean [alternative interpretation based on common usage]?"

**When to trigger:** Any time a feature involves a noun that is also an API entity name. Common examples:
- "attachment" — API entity (external resource link) vs. file embedded in description/comment
- "comment" — standalone comment entity vs. inline note in description
- "label" — issue label vs. project label vs. custom field

**Why:** Two incidents caused full implementation reversals because "attachments" was mapped to the Linear `Attachment` API entity (external resource links) when the user meant files/images embedded in issue descriptions.

## Write Operation Destination

For any create, upload, add, or attach action, ask:

"Where should the result end up? Options: [list concrete destinations relevant to the platform]"

Example destinations:
- Issue description body (inline)
- New comment on the issue
- Separate API entity (e.g., Attachment resource)
- Metadata field
- Custom field

**When to trigger:** Any requirement that involves creating or placing content.

**Why:** "Upload file to an issue" was implemented as creating a new comment, when the user meant appending to the issue description body.

## Output Verification

Before finalizing requirements (during the Verification section group), ask:

"After this feature is done, what would the output look like? For example, what would `[relevant command]` show?"

**When to trigger:** Always, as part of the Verification section approval.

**Why:** Both incidents would have been caught if the user had been asked to describe the expected output before requirements were finalized.

## Workflow Anchoring

When the user references a UI concept ("that attach button", "the upload dialog", "drag and drop"), ask:

"Can you describe the exact UI workflow you're modeling after? What steps does the user take in the UI, and what do they see after?"

**When to trigger:** Any time the user references a UI interaction as the model for a CLI/API feature.

**Why:** Mapping UI behavior to API behavior requires understanding the exact UI workflow, not just the UI element name.
