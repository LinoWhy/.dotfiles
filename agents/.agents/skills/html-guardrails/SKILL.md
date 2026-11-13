---
name: html-guardrails
description: Use when creating, editing, or reviewing HTML to improve reading order, visual hierarchy, control relevance, and mathematical typesetting.
---

# HTML Presentation Guardrails

This skill addresses redundant content, unnecessary controls, unclear reading order and hierarchy, and mathematical typesetting in HTML.

When wording or content organization is involved, **read and follow [writing-guardrails](../writing-guardrails/SKILL.md)**.

**Explicit user requirements and applicable project conventions take precedence.** These constraints take precedence over general HTML design and template guidance only for the issues they explicitly address. Choose the overall visual direction to suit the audience, purpose, and subject, using the relevant design skill.

## Feature Scope

- **Every visible control must serve a clear reader task or user requirement.** Capabilities and implementation guidance mentioned in a skill do not automatically become page features; print styles, for example, do not require a print button. Omit controls without a clear purpose in the task.

## Information and Reading Order

- Decide what each content area helps readers understand, decide, or accomplish before choosing its primary form. Do not automatically repeat the same information as a heading, introduction, card, and flowchart. When prose, diagrams, tables, or lists coexist, give each a complementary role.
- For reading pages, use headings that help readers locate information and prose that develops it coherently; for presentations, emphasize the main idea and key evidence. Organize implementation entry points, derivations, and supplementary material for consultation as needed. Keep the premises and evidence needed to understand a conclusion on the main reading path.
- Treat eyebrows, subtitles, descriptive lines, and endnotes in templates as optional. Remove unused slots and their placeholders instead of adding text to fill the layout. When simplifying an existing page, preserve effective layout and navigation, adapting them when the task calls for a different structure.

## Visual Hierarchy

- Use consistent visual roles for headings, body text, and supporting information, and style content at the same level consistently. **Give each area a clear primary focus**, with type size, weight, color, spacing, and grouping supporting the reading order.
- Use labels, background fills, and callouts selectively for grouping, navigation, comparison, emphasis, or state. Visual rhythm and a coherent identity suited to the subject are also valid design goals. Reduce competing emphasis that obscures hierarchy.
- Use code styling for identifiers, commands, and paths that readers need to identify precisely or copy, not to emphasize ordinary technical terms.

## Mathematical Notation

- **Write formulas in LaTeX and render them as mathematical notation.** Retain necessary variable definitions and units; do not deliver raw markup or manually assembled mathematical characters as the finished display. Keep code examples styled as code.
- Math rendering must also meet the artifact's offline and asset packaging requirements.

## Final Review

Review the final page against its audience and purpose, including how readily readers grasp the main points, follow the reading or task flow, and locate details. Check control relevance, complementary representations, visual hierarchy, and mathematical rendering. Remove redundancy and strengthen or add structure where grouping, navigation, or emphasis is insufficient.
