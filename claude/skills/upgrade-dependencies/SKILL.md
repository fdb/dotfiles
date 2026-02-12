---
name: upgrade-dependencies
description: Upgrade npm dependencies and GitHub Actions safely, testing between each change
---

# Upgrade Dependencies

Upgrade npm dependencies and GitHub Actions while continuously verifying nothing breaks.

## Principles

- **Test after every change** — build, lint, and test between each upgrade group
- **Commit each group separately** — easier to bisect and rollback
- **Patch/minor first, major last** — save breaking changes for dedicated effort
- **Do NOT upgrade Node.js itself** — out of scope for this skill

## Procedure

### 1. Pre-flight

Ensure clean state:

```bash
git status
npm ci
npm run build && npm test
```

If the build or tests fail before you start, stop and tell the user.

### 2. Discover outdated packages

```bash
npm outdated
npm audit
```

Categorize into groups:
1. **Security fixes** (`npm audit`) — urgent
2. **Production deps** (patch/minor) — `dependencies` in package.json
3. **Dev deps** (patch/minor) — `devDependencies` in package.json
4. **GitHub Actions** — `.github/workflows/*.yml`
5. **Major version bumps** — save for last, ask user before proceeding

Present the upgrade plan to the user with `AskUserQuestion` before starting.

### 3. Upgrade loop

For each group, repeat this cycle:

1. **Upgrade** the packages (`npm install <pkg>@latest` or `npm audit fix`)
2. **Verify** — run the project's build, test, and lint commands
3. **Commit** if green — use a descriptive message listing what changed and version numbers
4. **Rollback** if red — `git checkout package.json package-lock.json && npm ci`, then investigate

Group related packages together (e.g. all `@types/*`, all test framework packages).

### 4. GitHub Actions

Check for newer versions:

```bash
grep -r "uses:" .github/workflows/ | grep -v "#"
```

For each action, check the latest release:

```bash
gh api repos/{owner}/{action}/releases/latest --jq '.tag_name'
```

Update version pins in workflow files, commit, and verify CI passes.

### 5. Major upgrades

For each major version bump:

- Ask the user if they want to proceed
- Create a dedicated branch if the user prefers
- Check the package's changelog/migration guide
- Upgrade, fix breaking changes, verify, commit

### 6. Final validation

```bash
rm -rf node_modules
npm ci
npm run build && npm test && npm run lint
npm audit
npm outdated
```

Report a summary of what was upgraded, what was skipped, and any remaining outdated packages.
