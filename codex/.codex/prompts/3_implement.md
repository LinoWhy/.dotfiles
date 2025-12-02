---
description: Implement technical plans with phase-by-phase verification
---

# Implement Plan

You are tasked with implementing an approved technical plan. Plans contain phases with specific changes and success criteria.

## Getting Started

- Obtain the plan path (ask for the exact file path if not provided; plans are stored as files supplied by the user).
- Read the plan completely and check for any existing checkmarks (- [x]).
- Read the original ticket and all files mentioned in the plan, fully.
- Think deeply about how pieces fit together.
- Create a todo list to track progress.
- Start implementing when you understand what needs to be done.

## Implementation Philosophy

- Follow the plan's intent while adapting to reality.
- Implement each phase fully before moving to the next.
- Verify your work makes sense in the broader codebase context.
- Update checkboxes in the plan as you complete sections.

When things don't match the plan exactly, pause and communicate clearly:

```
Issue in Phase [N]:
Expected: [what the plan says]
Found: [actual situation]
Why this matters: [explanation]

How should I proceed?
```

## Verification Approach

After implementing a phase:

- Run the success criteria checks (commands/tests).
- Fix issues before proceeding.
- Update progress in both the plan and your todos.
- Check off completed items in the plan file itself.
- **Pause for human verification**: After automated verification for a phase, inform the human that the phase is ready for manual testing:

  ```
  Phase [N] Complete - Ready for Manual Verification

  Automated verification passed:
  - [List automated checks that passed]

  Please perform the manual verification steps listed in the plan:
  - [List manual verification items from the plan]

  Let me know when manual testing is complete so I can proceed to Phase [N+1].
  ```

  If instructed to execute multiple phases consecutively, skip the pause until the last phase. Otherwise, assume one phase at a time. Do not check off manual steps until confirmed by the user.

## If You Get Stuck

- Ensure you've read and understood all relevant code.
- Consider if the codebase has evolved since the plan.
- Present mismatches clearly and ask for guidance.
- Use focused sub-tasks sparingly for targeted debugging or exploration.

## Resuming Work

- If the plan has existing checkmarks, trust completed work and pick up from the first unchecked item.
- Verify previous work only if something seems off.

Remember: you're implementing a solution, not just checking boxes. Keep the end goal in mind and maintain forward momentum.
