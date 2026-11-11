---
name: knowledge-input
description: Use only when explicitly invoked to distill user-selected sources into knowledge notes and add or update them in a knowledge base.
disable-model-invocation: true
---

# Knowledge Input

Distill the selected sources into standalone, reusable notes. Follow the user's requirements and the knowledge base's existing conventions for destination, directory structure, and naming.

## Extract and Merge

- Read the relevant text, figures, and existing notes. Preserve mechanisms, evidence, applicable conditions, and necessary formulas and examples. State any coverage gaps that affect the conclusions.
- Ground the notes in the sources. Distinguish general knowledge from specific cases; do not turn facts about a particular project into universal rules.
- Prefer updating existing notes on the same topic. Preserve differences in versions, conditions, and viewpoints when merging sources. Split notes only when each can be understood and maintained independently; do not impose a fixed count.
- Keep diagrams and charts that aid understanding. Inspect images directly and follow the knowledge base's existing attachment directories and reference conventions.

## De-identification

Determine what needs de-identification from the user's requirements and the target knowledge base's confidentiality rules. When de-identification is needed:

- Preserve mechanisms and technical meaning while removing identifying details, internal source locations, private deployment details, and business data. Use role or concept names for necessary entities; do not keep a reversible alias mapping.
- Replace private measurements and configurations with the necessary trends, relative relationships, or orders of magnitude. Retain public facts and generic technical constants. State any loss of key evidence; do not invent replacement facts.
- Apply the same checks to image content, filenames, and source links. Redraw or omit figures containing private information, and check whether combining notes could reveal private information.
- Process source material that has not been de-identified in a temporary directory, clean it up afterward, and do not write it to the target knowledge base.

## Write and Verify

Check conclusions and necessary details against the sources. Verify that links and attachments work and meet de-identification requirements. Save only the needed notes and attachments; do not automatically create process logs or indexes.
