---
name: knowledge-query
description: Use only when explicitly invoked to search local personal notes, work records, and source indexes for answers about saved notes, past solutions, or comparisons across notes. Read-only by default; not for general questions that do not require note retrieval.
disable-model-invocation: true
---

# Knowledge Query

Locate relevant notes and source records in the knowledge base specified by the user or in the current workspace, following the existing directory structure.

## Search and Verify

1. Break the question into topic, subject, time, or version constraints. Use `rg --files` to inspect relevant directories, then `rg -n` to search terms, aliases, and key implementation names.
2. Read the full relevant passages around matches, following internal links and attachments as needed. Inspect images when explaining them; do not infer their conclusions from filenames.
3. If notes are insufficient, consult existing source records and environment instructions, then read the original documents or code within the task's scope. Attribute any supplementary external material, and honor requests to search locally only. Missing, inaccessible, or unread material does not count as verified.
4. Check dates, versions, applicability, and whether a record describes a historical project plan. Preserve conflicting findings and differences in conditions. Do not treat past conclusions as current status or choices for a specific platform as universal requirements.

## Answer

Answer the question first, linking to the relevant note, section, or original source near each conclusion. Distinguish facts directly supported by records, inferences across sources, and evidence gaps. Explain the basis for inferences; do not fill gaps in work records from model memory.

When the user requests de-identification or external sharing, follow their de-identification requirements and exclude private identifiers. Ordinary personal queries may retain the work context needed to answer the question.

By default, answer only in the conversation. Save or update content only when the user requests it, preferring existing notes. Use `knowledge-input` only if the user explicitly invokes it. Do not automatically create query logs, copies of Q&A, indexes, or a fixed number of follow-up questions.
