---
name: shell-scripts
description: Use when creating or editing shell scripts (.sh files), writing bash commands to a file, or generating deployment/build scripts
---

# Shell Script Best Practices

Apply these conventions to every shell script you write or modify.

## Required Header

Every script must start with:

```bash
#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")"
```

### What strict mode does

| Flag | Effect |
|------|--------|
| `set -e` | Exit immediately on any non-zero exit code |
| `set -u` | Treat unset variables as errors (catches typos like `$BUKCET`) |
| `set -o pipefail` | Fail pipelines if *any* command fails, not just the last one |

### Why `cd "$(dirname "$0")"` matters

Scripts should work regardless of where they're invoked from. This line changes to the script's own directory so relative paths (like `./build.sh` or `cp -r media out/`) resolve correctly.

**Only omit** if the script genuinely needs to operate in the caller's working directory — and add a comment explaining why.

## Additional Conventions

- **Quote all variable expansions**: `"$var"`, `"${arr[@]}"` — unquoted variables break on spaces and glob characters.
- **Use `[[ ]]` over `[ ]`**: Double brackets prevent word splitting and support pattern matching.
- **Prefer `$()` over backticks**: Clearer, nestable, and avoids escaping issues.
- **No unnecessary dependencies**: Prefer shell builtins over external commands when equivalent (e.g., `[[ -f file ]]` over `test -f file`).
