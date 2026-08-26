---
name: git-commit
description: "Analyze Git changes, draft or apply Conventional Commit messages, and verify the resulting commit. Use when the user asks to commit changes, write or revise a commit message, split changes into logical commits, or mentions /commit."
---

# Git Commit

## Workflow

Turn repository changes into a scoped, verifiable commit through this sequence:

`inspect → define boundary → stage → draft message → commit → verify → report`

For a message-only request, the sequence ends after the draft is presented. A commit request
reaches completion only after the verification step passes.

### 1. Inspect the repository

Run these commands:

```bash
git status --short
git diff --stat
git diff --cached
git diff
git log -n 20 --no-merges --format='%s%n%b%x00'
```

Read repository instructions, commit-lint configuration, and recent history for the affected files.
Use them to identify the established subject, language, capitalization, punctuation, body, footer,
and issue-reference conventions. When those conventions do not determine a material choice, ask
one grouped clarification before committing.

### 2. Define the commit boundary and stage it

Use the actual diff to group changes by logical intent, with one commit for each group. Preserve
user exclusions, unrelated existing index entries, secrets, and credentials outside the selected
group. The selected paths define the commit boundary. Stage them explicitly and inspect their
staged diff:

```bash
git add -- path/to/file1 path/to/file2
git diff --cached --name-only -- path/to/file1 path/to/file2
git diff --cached -- path/to/file1 path/to/file2
```

Continue when the listed staged paths exactly match the selected group. Existing index entries
outside the group remain untouched and outside the commit. When the selected staged diff is not
ready, resolve the boundary with the user before committing.

### 3. Draft the complete commit message

Base the message on the staged diff and repository conventions. Use the Conventional Commit form
unless the repository establishes another form:

```text
<type>[optional scope]: <imperative description>
```

Keep the title within 72 characters and ordinary body or footer prose within 80 characters per
line. Structure the message as one contiguous text block with a title, optional body, and footer;
separate those sections with one blank line. Explain motivation, trade-offs, user impact, migration
detail, or other behavior that the title cannot carry. Preserve URLs, hashes, commands, code
identifiers, standard trailers, and repository-generated `Change-Id` lines as structured content.
Apply the repository's rules for breaking changes, issue references, and attribution.

Present the complete message in a copyable code block for a message-only request. For a commit
request, present it before committing unless the user requested an unattended commit.

### 4. Commit the selected group

After the staged-path check passes, pass the complete drafted message as one standard-input stream
and keep the selected path list on the commit command:

```bash
git commit --file=- -- path/to/file1 path/to/file2 <<'EOF'
type(scope): title within 72 characters

Body prose is wrapped at 80 characters per line.
EOF
```

Run the standard Git commit with normal repository hooks enabled. A hook rejection returns to the
message or repository-fix stage, after which the sequence continues with the corrected input.

### 5. Verify the new commit and report it

After the commit command succeeds, capture the new commit and inspect all of the following:

```bash
commit_hash="$(git rev-parse --verify HEAD)"
git show -s --format='%H%nsubject: %s%n%n%B' "$commit_hash"
git diff-tree --root --no-commit-id --name-status -r "$commit_hash"
git status --short
```

Check that the hash identifies the new commit, the subject and raw message match the drafted
message plus any documented hook-generated content, the paragraph structure is intentional, the
committed paths exactly match the selected group, and the status output accounts for every
remaining change. Report the commit as complete after these checks pass.

This workflow creates the requested commit while preserving repository configuration, normal
hooks, existing history, and remote state. Configuration changes, remote operations, or history
rewrites belong to separate explicit requests.
