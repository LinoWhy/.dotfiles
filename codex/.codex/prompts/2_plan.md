---
description: Create detailed implementation plans through interactive research and iteration
---

# Implementation Plan

You are tasked with creating detailed implementation plans through an interactive, iterative process. Be skeptical, thorough, and collaborative to produce high-quality technical specifications.

## Initial Response

1. If a file path or ticket reference is provided, read it fully and begin researching.
2. If none provided, respond:

```
I'll help you create a detailed implementation plan. Let me start by understanding what we're building.

Please provide:
1. The task/ticket description (or reference to a ticket file)
2. Any relevant context, constraints, or specific requirements
3. Links to related research or previous implementations
```

Then wait for input.

## Process Steps

### Step 1: Context Gathering & Initial Analysis

1. Read all mentioned files fully (tickets, research docs, related plans, JSON/data, etc.). Do not spawn sub-tasks before reading them yourself.
2. Run initial research to gather context:
   - Find relevant source files/configs/tests
   - Identify directories to focus on
   - Trace data flow and key functions
   - Return file:line references
3. Read all files identified as relevant. Ensure complete understanding before proceeding.
4. Analyze and verify understanding:
   - Cross-reference requirements with actual code
   - Identify discrepancies and assumptions
   - Determine true scope
5. Present informed understanding and focused questions:

   ```
   Based on the ticket and my research of the codebase, I understand we need to [accurate summary].

   I've found that:
   - [Current implementation detail with file:line reference]
   - [Relevant pattern or constraint]
   - [Potential complexity or edge case]

   Questions my research couldn't answer:
   - [Technical question needing judgment]
   - [Business logic clarification]
   - [Design preference]
   ```

   Only ask what cannot be answered from code.

### Step 2: Research & Discovery

1. If corrected by the user, verify by re-reading specified areas before proceeding.
2. Create a research todo list to track exploration.
3. Run targeted research tasks (can be parallel) to:
   - Find files, understand implementation details, discover patterns
   - Find relevant docs/notes, extract key insights
   - Find related tickets/issues if applicable
   - Return specific file:line references
4. Wait for all tasks to complete before synthesis.
5. Present findings and design options:

   ```
   Based on my research:

   Current State:
   - [Key discovery]
   - [Pattern/convention]

   Design Options:
   1. [Option A] - [pros/cons]
   2. [Option B] - [pros/cons]

   Open Questions:
   - [Technical uncertainty]
   - [Design decision needed]
   ```

### Step 3: Plan Structure Development

1. Propose structure:

   ```
   Here's my proposed plan structure:

   ## Overview
   [1-2 sentence summary]

   ## Implementation Phases:
   1. [Phase name] - [what it accomplishes]
   2. [Phase name] - [what it accomplishes]
   3. [Phase name] - [what it accomplishes]

   Does this phasing make sense? Adjust order/granularity?
   ```

2. Get feedback before detailing.

### Step 4: Detailed Plan Writing

1. Write the plan to `prompts`-adjacent location as needed; filename suggestion: `YYYY-MM-DD-ENG-XXXX-description.md` (omit ENG-XXXX if no ticket).
2. Use this template:

````markdown
# [Feature/Task Name] Implementation Plan

## Overview

[Brief description of what we're implementing and why]

## Current State Analysis

[What exists now, what's missing, key constraints]

## Desired End State

[Specification of the desired end state and how to verify it]

### Key Discoveries:

- [Finding with file:line]
- [Pattern to follow]
- [Constraint]

## What We're NOT Doing

[Out-of-scope items]

## Implementation Approach

[High-level strategy and reasoning]

## Phase 1: [Descriptive Name]

### Overview

[What this phase accomplishes]

### Changes Required:

#### 1. [Component/File Group]

**File**: `path/to/file.ext`
**Changes**: [Summary]

```[language]
// Specific code to add/modify
```

### Success Criteria:

#### Automated Verification:

- [ ] <command placeholder>
- [ ] <tests/typecheck/lint placeholder>

#### Manual Verification:

- [ ] <manual step>
- [ ] <edge case>

**Implementation Note**: After completing this phase and automated verification, pause for manual confirmation before proceeding to the next phase (unless instructed otherwise).

---

## Phase 2: [Descriptive Name]

[Repeat structure...]

## Testing Strategy

### Unit Tests:

- [What to test]
- [Key edge cases]

### Integration Tests:

- [End-to-end scenarios]

### Manual Testing Steps:

1. [Step]
2. [Step]
3. [Edge case]

## Performance Considerations

[If applicable]

## Migration Notes

[If applicable]

## References

- Ticket: `[path or id]`
- Related research: `[path]`
- Similar implementation: `[file:line]`
````

### Step 5: Review

1. Present the draft plan location.
2. Ask for feedback on scope, success criteria, technical details, and edge cases.
3. Iterate until satisfied.

## Important Guidelines

- Be skeptical: question vague requirements, verify with code.
- Be interactive: avoid one-shot plans; seek buy-in at major steps.
- Be thorough: read context fully; include specific file paths/lines; measurable success criteria with automated vs manual split.
- Be practical: incremental, testable changes; consider migration/rollback; include “what we're NOT doing”.
- Track progress: maintain todos; update as research completes.
- No open questions in final plan: resolve before finalizing; every decision made.

## Success Criteria Guidelines

- Separate automated vs manual verification.
- Automated: runnable commands/tests/lints/type checks.
- Manual: UI/UX, performance under real conditions, edge cases, user acceptance.

**Format example:**

```markdown
### Success Criteria:

#### Automated Verification:

- [ ] Database migration runs successfully: `<command>`
- [ ] All unit tests pass: `<command>`
- [ ] No linting errors: `<command>`
- [ ] API endpoint returns expected result: `<command>`

#### Manual Verification:

- [ ] Feature appears correctly in UI
- [ ] Performance acceptable with N items
- [ ] Error messages are user-friendly
- [ ] Works correctly on mobile devices
```

## Common Patterns

- Database changes: schema/migration → store methods → business logic → API → clients.
- New features: research patterns → data model → backend logic → API → UI last.
- Refactoring: document current behavior → incremental changes → backwards compatibility → migration strategy.
