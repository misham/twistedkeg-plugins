# Conversation Techniques

## Core Principles

- **One question at a time** — never ask multiple questions in a single response
- **Multiple choice when possible** — lower friction than open-ended questions
- **Explain back for validation** — restate understanding before moving on
- **YAGNI ruthlessly** — actively push back on unnecessary complexity
- **Challenge assumptions** — ask "why" to uncover the real need behind requested features

## Elicitation Sequence

Follow this sequence, adapting based on what the user has already provided:

### 1. Problem Discovery
Start with the pain point, not the solution. If the user describes a solution, use the 5 Whys to find the root problem.

> "What's the single most important problem this solves?"

If the user jumps to solution-talk: "Before we get into how, let me understand why — what's the pain point that's driving this?"

### 2. User & Context
Understand who and when.

> "Who's the primary user, and what situation are they in when they need this?"

### 3. Happy Path
Walk through the ideal interaction.

> "Describe the perfect interaction from start to finish — what does the user do, and what happens?"

### 4. Scope Boundaries
Draw the line explicitly. Use the Is/Is Not pattern:
- It IS [type of thing]
- It is NOT [common misunderstanding]
- It DOES [key behavior]
- It does NOT [explicit exclusion]

### 5. Propose Approaches
Once the problem and scope are clear, propose 2-3 approaches with trade-offs before locking down requirements.

> "I see a few ways we could approach this. Let me lay them out with trade-offs, and we can pick the direction before nailing down the details."

For each approach:
- **Name** — a short, memorable label
- **How it works** — 2-3 sentences describing the approach
- **Trade-offs** — what you gain and what you give up
- **Recommendation** — lead with your recommended approach and explain why

Rules:
- Always present at least 2 approaches, max 3
- Include a "simplest possible" approach as one option — it anchors scope
- Make trade-offs concrete and specific, not abstract ("adds ~200ms latency" not "slightly slower")
- After the user selects, confirm what's included and excluded based on that choice
- The selected approach goes into the "Considered Approaches" section of the requirements doc
- Do NOT design the solution — describe approaches at the level of "what kind of thing we're building", not implementation details

### 6. Acceptance Criteria
Convert each requirement to Given/When/Then format. Apply the V-Bounce Rule: if a requirement cannot be translated into a testable acceptance criterion, it is not ready — flag it and resolve it.

### 7. Constraints & Assumptions
Probe for hidden assumptions using the Assumption Auditor pattern: for every stated requirement, identify one unstated assumption and ask a question that would disprove it.

### 8. Validation
How will we know it works?

> "How would you verify this feature works correctly? What would you test?"

## Scope Management

### Decomposition
If the feature spans multiple independent subsystems, decompose into sub-requirements. Each requirements doc maps to its own research + plan cycle. Use the INVEST criteria: Independent, Negotiable, Valuable, Estimable, Small, Testable.

### Simplification
At each step, ask: "Is this the simplest version that solves the problem?" Push back on gold-plating.

### Ambiguity Detection
Watch for fuzzy words: "fast", "user-friendly", "secure", "easy", "flexible", "robust". For each, ask for 3 specific, measurable criteria.
