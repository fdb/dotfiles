---
name: ship
description: Commit all changes, push to remote, and create a PR if on a feature branch
---

# Ship

Sequence: **commit → push → PR**.

1. **Commit** any pending changes using the standard git-commit workflow (HEREDOC message, `Co-Authored-By: Claude` trailer, stage by name). Skip if nothing to commit.
2. **Push** the current branch to `origin` (use `-u origin HEAD` if no upstream).
3. **PR** — only if the current branch is *not* the repo's default branch (`git symbolic-ref refs/remotes/origin/HEAD`):
   - Check `gh pr view --json url 2>/dev/null` first. If a PR exists, report its URL and stop.
   - Otherwise, create one with `gh pr create` using the standard `## Summary` / `## Test plan` body. Report the URL.

## Rules for the PR body

Write it as if a human wrote it. Do **not** include:

- "Generated with Claude Code", "Made with Claude", or similar attribution footers.
- Links to `claude.ai/...` sessions or transcripts — they return 403 for anyone but the author.
- Robot-emoji footers tied to Claude attribution.

The `Co-Authored-By: Claude` trailer in the *commit message* is fine — it's git-native metadata that GitHub renders as a co-author badge, not body decoration.
