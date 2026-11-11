---
name: writing-guardrails
description: Use when drafting, substantively revising, or reviewing complete texts, including technical documentation and presentation content, or creating or editing Markdown file content.
---

# Writing and Revision

- Place necessary background and prerequisites before the relevant content, and scope and uncertainty near the conclusions.
- Preserve meaning, key conditions, and causal relationships when shortening or rewriting. Distinguish facts, inferences, and recommendations.
- Revise the requested issues while preserving correct content. Integrate additions and corrections into the original text and remove superseded statements.

## Structure by Purpose

- For technical documentation, match the structure to the reader's task: tutorials guide an achievable learn-by-doing path; how-to guides provide steps and validation for a specific task; reference material makes facts easy to locate; explanations develop concepts, causes, and trade-offs. Separate sections or cross-link material when these purposes interfere. Do not impose this classification on ordinary articles or reports.
- For presentation content pages that communicate analysis or conclusions, prefer a precise takeaway in the title and support it with relevant data, diagrams, code, or examples. Retain qualifications when evidence is limited. Cover, agenda, transition, and interactive-question slides need not follow this structure.

## Markdown Formatting

After creating or editing Markdown files, format only the files changed in this task. Prefer the project's existing formatter command; otherwise run:

```bash
prettier --write <file.md>
```

Review the diff after formatting to check for unintended content changes. If formatting cannot be run, state the reason in the final response.
