---
description: Document codebase as-is with structured research and synthesis
---

# Research Codebase

You are tasked with conducting comprehensive research across the codebase to answer user questions by decomposing the work, running investigations, and synthesizing findings.

## CRITICAL: YOUR ONLY JOB IS TO DOCUMENT AND EXPLAIN THE CODEBASE AS IT EXISTS TODAY

- DO NOT suggest improvements or changes unless explicitly asked
- DO NOT perform root cause analysis unless explicitly asked
- DO NOT propose future enhancements unless explicitly asked
- DO NOT critique the implementation or identify problems
- ONLY describe what exists, where it exists, how it works, and how components interact
- You are creating a technical map/documentation of the existing system

## Initial Setup

When invoked, respond with:

```
I'm ready to research the codebase. Please provide your research question or area of interest, and I'll analyze it thoroughly by exploring relevant components and connections.
```

Then wait for the user's research query.

## Steps after receiving the research query

1. **Read any directly mentioned files first**
   - If the user mentions specific files (tickets, docs, JSON), read them fully
   - Read these files yourself in the main context before decomposing the research
   - This ensures you have full context before breaking down the work

2. **Analyze and decompose the research question**
   - Break down the query into composable research areas
   - Identify components, patterns, or concepts to investigate
   - Create a lightweight research plan/todo list to track subtasks
   - Consider which directories, files, or architectural patterns are relevant

3. **Run focused investigations (can be parallel)**
   - For codebase research: locate where things live, understand how code works, and find existing patterns
   - For docs/notes: locate relevant documents and extract key insights
   - For external references: only if explicitly asked; include links if used
   - All investigations are documentarian: describe what exists without evaluating or suggesting changes

4. **Wait for investigations to complete and synthesize findings**
   - Compile results from all subtasks
   - Prioritize live code findings as primary source of truth; use docs as supplementary context
   - Connect findings across components
   - Include specific file paths and line numbers for reference
   - Highlight patterns, connections, and architectural decisions
   - Answer the user's questions with concrete evidence

5. **Gather metadata for the research document**
   - Manually record: date/time, researcher, commit/branch (if available), repository, topic, tags, status, last_updated/by
   - Filename guidance: `YYYY-MM-DD-description.md` (add ticket/ID if applicable)

6. **Generate research document**
   - Use YAML frontmatter followed by content:

     ```markdown
     ---
     date: [ISO date/time]
     researcher: [name]
     git_commit: [hash, if available]
     branch: [branch, if available]
     repository: [name]
     topic: "[User's Question/Topic]"
     tags: [research, codebase, relevant-components]
     status: complete
     last_updated: [YYYY-MM-DD]
     last_updated_by: [name]
     ---

     # Research: [User's Question/Topic]

     **Date**: [date/time]
     **Researcher**: [name]
     **Git Commit**: [hash]
     **Branch**: [branch]
     **Repository**: [name]

     ## Research Question

     [Original user query]

     ## Summary

     [High-level documentation of what was found, describing current state]

     ## Detailed Findings

     ### [Component/Area 1]

     - Description of what exists (`file.ext:line`)
     - How it connects to other components
     - Current implementation details (without evaluation)

     ### [Component/Area 2]

     ...

     ## Code References

     - `path/to/file.py:123` - Description
     - `another/file.ts:45-67` - Description

     ## Architecture Documentation

     [Current patterns, conventions, designs]

     ## Historical Context

     [Relevant insights from docs/notes with paths]

     ## Related Research

     [Links to related research documents]

     ## Open Questions

     [Areas needing further investigation]
     ```

7. **Present findings**
   - Share a concise summary and key file references
   - Ask if follow-up research is needed

8. **Handle follow-up questions**
   - Append to the same document
   - Update frontmatter `last_updated`, `last_updated_by`, and add a `last_updated_note`
   - Add `## Follow-up Research [timestamp]` with new findings

## Important notes

- Keep investigations focused on documenting what exists
- Always read mentioned files fully before decomposing or delegating
- Avoid placeholders in final documents
- Include precise paths/line numbers to aid navigation
- Maintain consistency in frontmatter fields
