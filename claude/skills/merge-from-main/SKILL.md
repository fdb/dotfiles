---
name: merge-from-main
description: Fetch the latest changes from origin and merge main into the current branch, resolving any merge conflicts.
disable-model-invocation: true
---

# Merge from main

Fetch the latest changes from origin and merge main into the current branch, resolving any merge conflicts.

## Steps

1. Run `git fetch origin` to get the latest remote state.
2. Identify the current branch with `git branch --show-current`.
3. If already on `main`, run `git merge origin/main` instead of merging main into itself.
4. If on a feature branch, run `git merge origin/main` to merge remote main into the current branch.
5. If there are merge conflicts:
   - Run `git diff --name-only --diff-filter=U` to list conflicted files.
   - Read each conflicted file and resolve conflicts by understanding both sides.
   - Prefer keeping both changes when they don't contradict each other.
   - When changes conflict logically, favor the current branch's intent while incorporating main's structural changes (new imports, renamed symbols, etc.).
   - Stage resolved files with `git add <file>`.
6. After all conflicts are resolved, finalize with `git commit` (use the auto-generated merge message).
7. Verify the project still builds and tests pass. Detect the project type and run the appropriate commands:
   - **Rust/Cargo:** `cargo build --workspace && cargo test --workspace`
   - **Node/npm:** `npm run build && npm test` (or `npm run check` if available)
   - **Node/pnpm:** `pnpm build && pnpm test`
   - **Python/poetry:** `poetry run pytest`
   - **Python/pip:** `pytest`
   - If multiple project types coexist (e.g. a monorepo), run checks for each.
8. If build or tests fail, fix the issues and amend the merge commit.
9. Report the result: how many conflicts were resolved, what files were affected, and whether build/tests pass.
