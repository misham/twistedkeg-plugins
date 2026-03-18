# Disambiguation Rules

## API Entity Verification

During plan creation, when referencing an API entity, explicitly state the mapping:

"This plan uses the [Entity] API, which represents [description]. This matches the requirements document's intent of [what the user asked for]."

**When to trigger:** Any time a plan phase involves an API entity that was disambiguated during requirements gathering.

**Why:** Even after requirements are clear, the plan can re-introduce ambiguity if it references API entities without confirming the mapping.

## Output Examples in Plan

Each phase that produces user-visible output should include a concrete example:

```
### Expected Output:
After this phase, running `[command]` will show:
[exact example output]
```

**When to trigger:** Every phase that changes what the user sees (CLI output, TUI views, file contents).

**Why:** Output examples make misalignment visible before implementation begins. Both historical incidents would have been caught at the plan level if output examples had been included.
