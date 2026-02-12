---
name: ship
description: Commit all changes, push to remote, and create a PR if on a feature branch
---

# Ship — Commit, Push & Create PR

Commit all staged/unstaged changes, push to origin, and if on a feature branch, create a pull request.

## Steps

### 1. Assess the current state

Run these commands to understand the current state:

- `git status` — check for uncommitted changes (never use `-uall`)
- `git diff` and `git diff --staged` — see what will be committed
- `git branch --show-current` — get the current branch name
- `git log --oneline -10` — check recent commit style

### 2. Stage and commit (if there are changes)

If there are unstaged or staged changes:

1. Stage relevant files by name (prefer `git add <file>...` over `git add -A`). Do not stage files that look like secrets (`.env`, credentials, keys).
2. Generate a concise commit message that follows the repo's existing commit message style (check recent `git log`). Summarize the "why" not the "what".
3. Commit using a HEREDOC for the message:

```bash
git commit -m "$(cat <<'EOF'
Your commit message here.

Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>
EOF
)"
```

If there are no changes to commit, move on to the push step.

### 3. Push to origin

Push the current branch to origin. If the branch has no upstream, use `-u` to set it:

```bash
git push -u origin HEAD
```

If the branch is already pushed and up-to-date, skip this step.

### 4. Detect the default/main branch

Determine the repo's default branch:

1. Try: `git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@'`
2. If that fails, check if `origin/main` exists: `git rev-parse --verify origin/main 2>/dev/null`
3. If that fails, check if `origin/master` exists: `git rev-parse --verify origin/master 2>/dev/null`
4. If none of the above work, use `AskUserQuestion` to ask the user what the base branch should be.

### 5. Check if on the main branch

Compare the current branch name to the detected default branch. If they match, stop here — no PR is needed. Report that changes have been committed and pushed.

### 6. Create a PR (feature branches only)

First check if a PR already exists for this branch:

```bash
gh pr view --json url 2>/dev/null
```

If a PR already exists, report the existing PR URL and stop.

If no PR exists, create one:

1. Determine the base branch from step 4.
2. Generate a PR title (short, under 70 characters) and description (summary of commits since branching off base) using `git log <base>..HEAD --oneline` and `git diff <base>...HEAD --stat`.
3. Create the PR:

```bash
gh pr create --title "Your PR title" --body "$(cat <<'EOF'
## Summary
- Bullet points summarizing the changes

## Test plan
- [ ] Verification steps

🤖 Generated with [Claude Code](https://claude.com/claude-code)
EOF
)"
```

4. Report the PR URL to the user.
