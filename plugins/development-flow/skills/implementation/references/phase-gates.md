# Phase Gate Protocol

## After Completing All Changes in a Phase

1. **Run all automated verification** listed in the phase's success criteria
2. **Fix any failures** before proceeding — do not move to next phase with failing checks
3. **Mark phase as complete** (`✅ COMPLETE`) in the plan file
4. **Proceed to next phase** — no manual verification pause between phases

If the plan explicitly requests per-phase manual verification for a specific phase, pause at that phase.

## Plan Completion Gate

After ALL phases are complete and all automated checks pass:

1. **STOP implementation**
2. **Present final manual verification** to the user:

```
═══════════════════════════════════════════════════════
⏸️  ALL PHASES COMPLETE - AWAITING MANUAL VERIFICATION
═══════════════════════════════════════════════════════

All automated verification passed across [N] phases.

Manual verification steps from plan:

- [ ] Step 1
- [ ] Step 2
- [ ] ...

Reply "done" when manual verification is complete.
═══════════════════════════════════════════════════════
```

3. **Wait for user confirmation** before marking plan as fully complete

## Handling Mismatches

When the plan doesn't match reality:

```
Issue in Phase [N]:
Expected: [what the plan says]
Found: [actual situation]
Why this matters: [explanation]

How should I proceed?
```

## Phase Status Updates

- After automated checks pass: mark phase as `✅ COMPLETE`
- After plan completion gate: mark plan as fully complete
- Do not check off manual testing items until confirmed by user
