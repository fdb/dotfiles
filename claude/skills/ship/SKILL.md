---
name: ship
description: Commit all changes, push to remote, and create a PR if on a feature branch
---

# Ship

Commit pending changes and publish them.

1. **Commit** any pending changes using the standard git-commit workflow (HEREDOC message, `Co-Authored-By: Claude` trailer, stage by name). Skip if nothing to commit.

2. **Decide whether to open a PR**:
   - Feature branch → yes.
   - Default branch (`git symbolic-ref refs/remotes/origin/HEAD`) → no, *unless* the user asked for one in their `/ship` invocation (e.g. `/ship make a pr for this`).

3. **No PR** → push the current branch to `origin` (use `-u origin HEAD` if no upstream). Done.

4. **PR**:
   - If on the default branch, first move the new commits to a fresh feature branch — do not push them to the default branch.
   - Push the feature branch.
   - Check `gh pr view --json url 2>/dev/null`. If a PR exists, report its URL and stop. Otherwise create one with `gh pr create` using the standard `## Summary` / `## Test plan` body. Report the URL.

## Rules for the PR body

Write it as if a human wrote it. Do **not** include:

- "Generated with Claude Code", "Made with Claude", or similar attribution footers.
- Links to `claude.ai/...` sessions or transcripts — they return 403 for anyone but the author.
- Robot-emoji footers tied to Claude attribution.

The `Co-Authored-By: Claude` trailer in the *commit message* is fine — it's git-native metadata that GitHub renders as a co-author badge, not body decoration.
