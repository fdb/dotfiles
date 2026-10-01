---
name: ship
description: Publish local work and confirm the result. In our own repos this means check, commit, push to the default branch, and deploy; in a worktree of our own repo it means a pull request; in a repo owned by someone else it means a full review, one purpose per commit, and a drafted pull request that waits for confirmation before anything is sent. With "land", finishes merged work - pull the default branch, deploy, confirm the deployed version, remove the branch. Use when the user asks to ship, publish, commit and push, open a PR, or says that a PR is merged and must be deployed.
---

# Ship

Publish local work, and observe each result before you report it. The repo's AGENTS.md gives the verify command, the branch policy, the base branch, and the deploy command. If the verify command, the branch policy, or the base branch is absent when you need it, ask one time and record it there. If AGENTS.md gives no deploy command, the repo has nothing to deploy: skip the deploy and do not ask.

## Choose the mode

Read two facts before you do anything else, and name the mode in your first line.

- The owner in `git remote get-url origin` (and in `upstream`, if that remote exists). The owners fdb, codespacehelp, algorithmicgaze, figmentapp, gandelve, and nodebox are ours. A fork of someone else's repo counts as theirs, even when the fork is under one of our owners.
- Whether the checkout is a linked worktree: `git rev-parse --git-dir` and `git rev-parse --git-common-dir` give different paths.

| Repo | Checkout | Mode |
| --- | --- | --- |
| ours | main checkout | **Direct**: commit, push to the default branch, deploy |
| ours | linked worktree, or AGENTS.md forbids commits on the default branch | **PR**: commit, push the branch, open a pull request |
| someone else's | any | **Upstream**: review, clean commits, draft the pull request, wait for confirmation |

A word from the user in the invocation wins over the table: `/ship make a pr` uses PR mode in a main checkout, `/ship no deploy` skips the deploy.

## Direct

1. **Check.** Run the repo's verify command (tests, type check, lint). If it fails, stop and show the failure; do not commit around it. If the repo has no verify command, say so in the report.

2. **Commit** pending changes with the standard git-commit workflow (HEREDOC message, stage by name). Stage only files that belong to the work; name any file that you left out. Skip if there is nothing to commit.

3. **Push** the default branch to `origin`. Then observe it: `git status -sb` shows no commits ahead of the upstream.

4. **Deploy** with the repo's deploy command. Apply pending database migrations in the order that the repo records, before code that needs them goes live. Then observe the deploy: the version or commit-hash endpoint reports the expected commit, and the health check or a smoke request passes. If the repo has no such endpoint, make one real request and say what it returned. Skip this step if AGENTS.md gives no deploy command.

## PR

1. **Check** and **commit** as in Direct. If the new commits are on the default branch, move them to a fresh feature branch first; do not push them to the default branch.

2. **Push** the branch (`-u origin HEAD` if there is no upstream) and observe it with `git status -sb`.

3. **Open the pull request.** Use the base branch from the repo's AGENTS.md. Check `gh pr view --json url 2>/dev/null`; if a PR exists, report its URL. Otherwise read the whole change against the base (`git diff <base>...HEAD`), write the body by the rules below, and create it with `gh pr create`. If the change touches a surface that other people use, run `/due-diligence` before you create it.

This mode does not deploy. The deploy happens in Land, after the merge.

## Upstream

The pull request goes out under the user's name to people who do not know them, so this mode is slow on purpose. Nothing leaves the machine until the user confirms: no push, no PR, no comment.

1. **Read their rules.** CONTRIBUTING, the PR template, the commit message convention, and three or four recently merged PRs (`gh pr list --state merged --limit 5`, then `gh pr view <n>`). Follow what you find, including where it differs from the rules below.

2. **Check** with the project's own test and lint commands.

3. **Review every changed line.** Fetch the target and read `git diff <upstream-base>...HEAD` in full, plus the uncommitted changes. For each hunk, say which part of the PR's purpose it serves. Take out every hunk that serves none: reformatting of lines you did not otherwise change, reordered imports, lockfile or generated-file churn, debug output, commented-out code, editor or agent files, changes to their AGENTS.md, CI, or contributor docs. A second fix that you found along the way is a separate PR; move it to its own branch and tell the user it exists.

4. **One commit does one thing.** Each commit builds and passes the tests alone, and its message describes that one change in their convention. If the history has fixups, mixed commits, or work-in-progress messages, rebuild it on the current upstream base. Make a backup branch before you rewrite. Check the commits for AI attribution trailers and remove them.

5. **Read it again as the maintainer.** Run `git log --stat <upstream-base>..HEAD` and `git diff <upstream-base>...HEAD` on the final branch and confirm that the file list contains only files the PR's purpose needs, and that the branch is based on the current upstream base with no merge commits from it.

6. **Draft, then stop.** Show the user: the target repo and base branch, the commit list with subjects, the diff stat, anything you took out in step 3, the result of the check, and the proposed title and body in a fenced block. Say what is not verified. Then wait.

7. **Send**, after the user confirms the text. Push the branch to the fork (`--force-with-lease` if the rewrite in step 4 changed commits that were already pushed there), create the PR with the confirmed title and body unchanged, and report the URL. If the user edits the text, use their text exactly.

## Land

Only when the user asks: `/ship land`, "merged", "deploy it". This finishes a PR-mode change after its merge.

- Switch to the default branch and pull. Confirm that it contains the work: the merge commit or the shipped commits are in `git log`.
- Deploy and observe the deploy as in Direct, step 4, with the same skip.
- Delete the merged feature branch, local and remote, and its worktree if it has one. Never delete an unmerged branch.

## Report

Compact lines, each with its evidence: the mode, the check result, the short hash and exact commit subject, the push state, the PR URL if any, the deployed version if any. Mark anything that you could not observe as "not verified". Then stop.

## Rules for the PR body

The goal is a PR body that earns its keep — concise, specific, and useful to a reviewer who has not seen the diff yet. The same standards apply whether a human or Claude is drafting; we are not disguising authorship, we are avoiding the patterns that make AI-written PRs tedious to review.

**Structure**:
- `## Summary` — lead with *why* (the problem, the trigger, the linked issue), then *what* the change does at a high level. Not a file-by-file enumeration; the diff already shows that.
- `## Test plan` — concrete commands or steps a reviewer can run, or what was verified locally. If genuinely not applicable (e.g. docs-only), say so in one line rather than padding.
- In Upstream mode, the project's PR template replaces this structure.

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
