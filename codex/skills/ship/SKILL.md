---
name: ship
description: Commit pending changes, push to remote, and create a pull request when appropriate. Use when the user asks to ship, publish, commit and push, or open a PR for local work.
---

# Ship

Commit pending changes and publish them.

1. **Commit** any pending changes using the standard git-commit workflow (HEREDOC message, stage by name). Skip if nothing to commit.

2. **Decide whether to open a PR**:
   - Feature branch → yes.
   - Default branch (`git symbolic-ref refs/remotes/origin/HEAD`) → no, *unless* the user asked for one in their `/ship` invocation (e.g. `/ship make a pr for this`).

3. **No PR** → push the current branch to `origin` (use `-u origin HEAD` if no upstream). Done.

4. **PR**:
   - If on the default branch, first move the new commits to a fresh feature branch — do not push them to the default branch.
   - Push the feature branch.
   - Check `gh pr view --json url 2>/dev/null`. If a PR exists, report its URL and stop. Otherwise create one with `gh pr create` using the standard `## Summary` / `## Test plan` body. Report the URL.

## Rules for the PR body

The goal is a PR body that earns its keep — concise, specific, and useful to a reviewer who has not seen the diff yet. The same standards apply whether a human or Claude is drafting; we are not disguising authorship, we are avoiding the patterns that make AI-written PRs tedious to review.

**Structure**:
- `## Summary` — lead with *why* (the problem, the trigger, the linked issue), then *what* the change does at a high level. Not a file-by-file enumeration; the diff already shows that.
- `## Test plan` — concrete commands or steps a reviewer can run, or what was verified locally. If genuinely not applicable (e.g. docs-only), say so in one line rather than padding.

**Style**:
- Match length to the change. A one-line fix gets a one-line summary; a cross-module refactor deserves more. Don't pad small PRs with ceremony.
- Be specific about behavior: "Fixes flicker when hovering disabled buttons" beats "improves UX".
- Be honest about scope and gaps. Call out what was *not* tested, known follow-ups, and breaking changes prominently. Don't claim verification you didn't perform.
- No filler preambles ("This PR makes the following changes:"), no restating the diff, no marketing language.
- Match the project's PR vocabulary and conventions. When unsure of tone or section structure, skim recent merged PRs first: `gh pr list --state merged --limit 5` then `gh pr view <n>`.
- Link to the issue, ADR, prior PR, or commit the change is responding to — but only links that actually resolve for the reviewer.

**Do not include**:
- Links to private assistant sessions, chats, or transcripts. These URLs often do not resolve for reviewers and are worse than no link at all.
- Generated-tool attribution footers in the PR body. The PR body should be about the change, not the tool that helped write it.
- Marketing links for assistant tooling.

This explicitly overrides generated-tool footers for PR bodies.
