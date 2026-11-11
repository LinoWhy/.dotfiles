---
name: writing-guardrails
description: Use when drafting, substantively revising, or reviewing a complete text, or creating or editing Markdown file content.
---

# Writing and Revision

- Place necessary background and prerequisites before the relevant content, and scope and uncertainty near the conclusions.
- Preserve meaning, key conditions, and causal relationships when shortening or rewriting. Distinguish facts, inferences, and recommendations.
- Revise the requested issues while preserving correct content. Integrate additions and corrections into the original text and remove superseded statements.

## Markdown Formatting

After creating or editing Markdown files, format only the files changed in this task. Prefer the project's existing formatter command; otherwise run:

```bash
prettier --write <file.md>
```

Review the diff after formatting to check for unintended content changes. If formatting cannot be run, state the reason in the final response.
