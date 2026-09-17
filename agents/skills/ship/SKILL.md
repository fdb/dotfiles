---
name: ship
description: Check, commit, and push local work, and confirm that the remote has it. Opens a pull request only when explicitly requested. With "land", finishes merged work - pull the default branch, deploy, confirm the deployed version, remove the branch. Use when the user asks to ship, publish, commit and push, open a PR, or says that a PR is merged and must be deployed.
---

# Ship

Publish local work, and observe each result before you report it. The repo's AGENTS.md gives the verify command, the branch policy, the base branch, and the deploy command. If one that you need is absent, ask one time and record it there.

1. **Check.** Run the repo's verify command (tests, type check, lint). If it fails, stop and show the failure; do not commit around it. If the repo has no verify command, say so in the report.

2. **Commit** pending changes with the standard git-commit workflow (HEREDOC message, stage by name). Stage only files that belong to the work; name any file that you left out. Follow the branch policy: if the repo forbids commits on the default branch, move to a feature branch first. Skip if there is nothing to commit.

3. **Push** the current branch to `origin` (use `-u origin HEAD` if there is no upstream). Then observe it: `git status -sb` shows no commits ahead of the upstream.

4. **PR**, only if the user asked for one in this invocation (for example `/ship make a pr for this`). A bare `/ship` never creates a PR, and does not draft or print a title or body.
   - If on the default branch, first move the new commits to a fresh feature branch — do not push them to the default branch.
   - Use the base branch from the repo's AGENTS.md.
   - Check `gh pr view --json url 2>/dev/null`. If a PR exists, report its URL. Otherwise create one with `gh pr create` using the standard `## Summary` / `## Test plan` body. Report the URL.

5. **Land**, only if the user asked: `/ship land`, "merged", "deploy it". A deploy reaches other people, so a bare `/ship` never deploys, unless the repo's AGENTS.md says that ship includes deploy.
   - Switch to the default branch and pull. Confirm that it contains the work: the merge commit or the shipped commits are in `git log`.
   - Run the deploy command. Apply pending database migrations in the order that the repo records, before code that needs them goes live.
   - Observe the deploy: the version or commit-hash endpoint reports the expected commit, and the health check or a smoke request passes. If the repo has no such endpoint, make one real request and say what it returned.
   - Delete the merged feature branch, local and remote, and its worktree if it has one. Never delete an unmerged branch.

6. **Report** in compact lines, each with its evidence: the check result, the short hash and exact commit subject, the push state, the PR URL if any, the deployed version if any. Mark anything that you could not observe as "not verified". Then stop.

## Rules for the PR body

These rules apply only when the user explicitly asked for a PR.

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
