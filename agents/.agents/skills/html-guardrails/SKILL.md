---
name: html-guardrails
description: Use when creating, editing, or reviewing HTML to constrain controls, layout, reading order, visual hierarchy, and mathematical typesetting.
---

# HTML Presentation Guardrails

This skill governs the visual presentation of HTML: controls, layout, reading order, visual hierarchy, and mathematical typesetting.

When wording or content organization is involved, **read and follow [writing-guardrails](../writing-guardrails/SKILL.md)**.

**Explicit user requirements and applicable project conventions take precedence.** Subject to those requirements, **this skill's presentation constraints take precedence** over general guidance in other HTML design, generation, and template skills.

## Feature Scope

- **Every visible control must serve a clear reader task or user requirement.** Capabilities and implementation guidance mentioned in a skill do not automatically become page features; print styles, for example, do not require a print button. Omit controls without a clear purpose in the task.

## Information and Reading Order

- Decide what each content area helps readers understand, decide, or accomplish before choosing its primary form. Do not automatically repeat the same information as a heading, introduction, card, and flowchart. When prose, diagrams, tables, or lists coexist, give each a complementary role.
- For reading pages, use headings that help readers locate information and prose that develops it coherently; for presentations, emphasize the main idea and key evidence. Organize implementation entry points, derivations, and supplementary material for consultation as needed. Keep the premises and evidence needed to understand a conclusion on the main reading path.
- Treat eyebrows, subtitles, descriptive lines, and endnotes in templates as optional. Omit unused content and its placeholder structure instead of adding text to fill the layout.

## Visual Hierarchy

- Use consistent visual roles for headings, body text, and supporting information, and style content at the same level consistently. **Give each area a clear primary focus**, with type size, weight, color, spacing, and grouping supporting the reading order.
- Avoid layering large and small text, standalone labels, background fills, or callout boxes onto every line. Additional emphasis must convey actual importance or state rather than merely add variation.
- Use code styling for identifiers, commands, and paths that readers need to identify precisely or copy, not to emphasize ordinary technical terms.

## Mathematical Notation

- **Write formulas in LaTeX and render them as mathematical notation.** Retain necessary variable definitions and units; do not deliver raw markup or manually assembled mathematical characters as the finished display. Keep code examples styled as code.
- Math rendering must also meet the artifact's offline and asset packaging requirements.

## Final Review

Review the final visible content and structure for justified controls, a clear reading order in each area, complementary representations, and visual emphasis and mathematical typesetting that aid understanding. Remove, combine, or reposition content where needed.
