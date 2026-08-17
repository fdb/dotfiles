---
name: due-diligence
description: Pre-ship due diligence for changes that touch an API others use. Contains an adversarial pass (imagine clients that break your model) and a field pass (find real call sites in the wild, track lifetimes and assumptions, check for breakage). Use before a PR that changes a public surface, when deprecating or removing anything, when hunting a regression in released code, or when the user says "due diligence".
---

# Due Diligence

Every change encodes a model of how clients use the system. Bugs live where the model is incomplete. Reviews and tests that share the model cannot find these bugs. This skill attacks the model two times: first with imagination, then with evidence.

The adversarial pass runs on your model. It finds what you can imagine. The field pass runs on real client code. It finds what you cannot imagine. Chrome tests new releases against a large set of real websites. Rust runs crater against all packages on crates.io. We do the same at small scale: read the clients we can find, before we ship.

Origin: a PR freed cached fonts when an activity finished. A check made sure no widget still drew the font. But one public app kept its font handle in a module global. The app applied the handle again on the next screen: use-after-free. Every imagined client matched the author's model. The real client was one code search away. We want to prevent these embarrassing bugs.

Do not run the client code. Read it. Find call sites. Track lifetimes and assumptions.

## Phase 1 — Map the changed surface

List each behavior that your change alters and that a client can observe. Hyrum's Law: with enough users, clients depend on every observable behavior, documented or not.

Check each category against your change:

- **Lifetime.** Who owns the values you return or free? How long can a client keep them?
- **Shape.** Fields, tuple size, types. Clients destructure, index, and serialize these.
- **Errors.** Exception types, error codes, sentinel returns (`None`, `-1`, empty). Clients branch on these.
- **Order and defaults.** Iteration order, sort order, default argument values.
- **Sequence.** The call order you intend (init → use → close), and the call orders that also work today.
- **Text output.** Log lines, CLI output, string formats. Scripts parse these.
- **Stored state.** Files, schemas, and caches that the old version wrote and the new version reads. Also the reverse.
- **Extension points.** Methods a subclass can override. Names a monkeypatch can target.
- **Timing and threads.** The thread or callback a client calls from. Code that was synchronous and is now async, slower, or cached.

Write a short list: "surfaces my change touches". All later phases use this list.

## Phase 2 — Adversarial pass (imagined clients)

Attack your own design before you look outside.

- List who touches each surface: direct callers, subclasses, background threads, scheduled callbacks, stored state, out-of-tree apps and plugins. The dangerous client is the one you cannot grep.
- Ask: "what does the dumbest reasonable client do?" Clients cache results. They keep references. They call twice. They call at the worst moment. They ignore your intended sequence. This is normal use, not abuse.
- Hunt for state that outlives your check. A check that scans the present is blind to the past. Clients carry the past in variables, globals, closures, caches, and queues.
- Attack each guarantee you claim. For each "safe", "idempotent", "thread-safe", or "cannot happen", ask: which test breaks it?

Write the hypotheses down. Phase 3 confirms or refutes them. Phase 3 also adds hypotheses you did not generate.

## Phase 3 — Field pass (real clients)

Find call sites in the wild. Read them.

### Where to look, in order of yield

1. **In-tree:** examples, tests, docs snippets, sibling apps in the monorepo.
2. **First-party ecosystem:** the project's known apps, plugins, and org repos. The platform's app store or package registry.
3. **Code search:** `gh search code "<api-name>" --language=<lang>`. GitHub web search (regex works). grep.app. Sourcegraph public search.
4. **Reverse dependencies:** the npm "dependents" tab, crates.io reverse deps, libraries.io for PyPI.
5. **Issue tracker and discussions:** pasted snippets show real usage, often the abusive kind.
6. **Forks:** a fork that patched around your API marks a pain point.

### What to record per call site

Write a short entry for each call site:

```
client + file:line
calls:      what, and when (startup, per-frame, teardown, callback)
stores in:  local / object field / module global / cache / queue
uses later: reapplies, iterates, compares, frees, never
assumes:    shape, error type, order, call sequence, lifetime
verdict:    OK / breaks / suspicious
```

The "stores in" and "uses later" lines trace the lifetime. The font bug needed this trace. Nobody made it.

### When to stop

Stop when new call sites show no new patterns. This usually takes 5–15 sites. One real counterexample is enough to change the design. You falsify; you do not survey. If you find zero clients, say so. "No visible clients" is a finding, not a free pass.

## Phase 4 — Confront

Put the two passes together. Check each observed usage pattern against each surface from Phase 1. Mark it: preserved, broken, or unclear.

- A pattern that looks abusive still counts. If the API allowed it, someone ships it.
- "Unclear" means: read more of that client until the mark resolves.
- One "broken" mark means: change the design, or make the break explicit with a migration note. Never break in silence.

## Phase 5 — Verdict and ship

- If a real client breaks, prefer a design that survives the observed pattern: additive changes, revocable handles, lifetime tied to GC, compat shims. If the break is intentional, write the migration note now.
- Turn the 2–3 most creative observed usages into client-side tests. These tests do what the real client does. They do not restate what the implementation believes.
- State the evidence in the PR: the venues you scanned, the number of clients, the patterns you found, the residual risk. When you find "this breaks if a client does X", that is engineering. When the maintainer finds it after merge, that is a revert.

## Inverted mode — regression hunting

A regression report in released code inverts the flow. Scan clients for the usage pattern that triggers the symptom. Look first at patterns the change's author classified as impossible or illegal. When you find the pattern, hand the repro to `/diagnose`.
