---
name: git-commit
description: "Analyze Git changes, draft or apply safe Conventional Commit messages, and keep the complete title within 72 characters and body prose within 80 characters. Use when the user asks to commit changes, write or revise a commit message, split changes into logical commits, or mentions /commit."
---

# Git Commit

## Policy

Keep the complete title within 72 characters and wrap body prose at 80 characters per line.

Repository-specific instructions, recent commit history, and configured commit linters take
precedence over these defaults. Never silently replace a clear repository convention.

The title is the complete first line, including the Conventional Commit type, scope, colon, and
space. Keep it imperative, specific, and free of a trailing period. Use this form by default:

```text
<type>[optional scope]: <imperative description>
```

Use the standard types (`feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`,
`ci`, `chore`, and `revert`) unless the repository already uses another approved type.

Separate title, body, and footer with one blank line. Add a body when the motivation, trade-off,
user impact, migration detail, or non-obvious behavior cannot be understood from the title.
Explain why and relevant behavior; do not narrate the diff or repeat file names.

Wrap ordinary body and footer prose at 80 characters. Do not mechanically break URLs, hashes,
commands, code identifiers, or standard trailers such as `Change-Id:`, `Signed-off-by:`,
`Fixes:`, or `Closes:`. Keep such structured lines intact even when they exceed 80 characters.
Never invent a Gerrit `Change-Id`; preserve an existing one or let the repository hook create it.

## Workflow

### 1. Inspect the repository

Run these as separate commands and treat non-zero exits as information to interpret:

```bash
git status --short
git diff --stat
git diff --cached
git diff
git log -n 20 --no-merges --format='%s%n%b%x00'
```

Check for repository instructions and commit-lint configuration before drafting. Use the recent
history of the affected files when it conflicts with the generic history sample. Ignore obvious
merge and bot commits when detecting style.

Detect, when the history is strong enough:

- subject format, type/scope convention, language, capitalization, and punctuation;
- whether bodies are usual and how they are structured;
- footer/trailer conventions and issue-reference syntax.

If the repository convention is genuinely inconclusive and the choice would materially affect
the message, ask one grouped clarification before committing. An explicit user preference wins.

### 2. Decide the commit boundary

Prefer one commit per logical change. If unrelated changes are mixed, identify the groups and
propose separate commits. Stage named files only; never use `git add .` or `git add -A`.

Do not include secrets or credentials (`.env`, private keys, tokens, credential files). Preserve
files the user explicitly excluded and preserve unrelated pre-existing index entries.

### 3. Draft and validate the message

Analyze the actual staged diff, not only filenames. Choose the type and scope from the change's
primary intent, then draft the title and optional body. Validate all of the following before
applying the commit:

- complete title is at most 72 characters;
- every ordinary body prose line is at most 80 characters;
- title/body/footer have the required blank-line separation;
- imperative mood and repository capitalization/punctuation are respected;
- breaking changes and issue references use the repository's established footer format;
- no AI attribution is added unless the repository explicitly requires it.

If the user asks only for a message, output a copyable code block and do not stage or commit.
If the user explicitly asks to commit, show the proposed message first unless they asked for an
unattended commit, then apply it with the standard Git command and normal hooks enabled.

### 4. Apply and confirm

Before committing, verify `git diff --cached --name-only` contains exactly the selected paths.
If unrelated paths or partial user staging make that impossible, stop and ask instead of
rewriting the index. Stage only the selected paths and commit with a message file or quoted
multi-line message. When path-scoped committing is safe, keep the path list on the commit command
so unrelated index entries cannot ride along:

```bash
git add -- path/to/file1 path/to/file2
git commit -m "$(cat <<'EOF'
type(scope): title within 72 characters

Body prose is wrapped at 80 characters per line.
EOF
)" -- path/to/file1 path/to/file2
```

Do not change Git configuration, skip hooks, amend, force push, or perform destructive history
rewrites unless the user explicitly requests that exact action.

After a successful commit, run `git status --short` and report the commit hash, subject, paths,
and any intentionally uncommitted files. If a hook rejects the commit, report the error, fix the
message or requested issue, and create a new commit; do not silently skip the hook or amend.

## Message examples

Short change:

```text
fix(auth): stop refresh retries after token expiry
```

Change needing context:

```text
refactor(cache): isolate eviction from request handling

Eviction callbacks could re-enter request handling while the cache lock was held,
causing latency spikes under concurrent misses. Move eviction to a queue so the lock
only protects the index and callbacks run after the request releases it.
```

Breaking change:

```text
feat(api)!: remove the legacy export endpoint

Clients must migrate to `/v2/exports` before the legacy route is removed.

BREAKING CHANGE: `/v1/exports` no longer accepts requests after the migration window.
```
