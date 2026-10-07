---
name: prototype
description: Build a throwaway prototype or quick tool to answer a question or serve a one-off need. Routes between three branches — a runnable terminal app for state/business-logic questions, several radically different UI variations toggleable from one route, or a standalone single-file tool that runs on file:// and persists to localStorage with no build step. Use when the user wants to prototype, sanity-check a data model or state machine, mock up a UI, explore design options, wants a quick throwaway tool, or says "prototype this", "let me play with it", "try a few designs", "build me a quick tool".
---

# Prototype

A prototype is **throwaway code that answers a question or serves a one-off need**. The request decides the shape.

## Pick a branch

Identify what is being asked — from the user's prompt, the surrounding code, or by asking if the user is around:

- **"Does this logic / state model feel right?"** → [LOGIC.md](LOGIC.md). Build a tiny interactive terminal app that pushes the state machine through cases that are hard to reason about on paper.
- **"What should this look like?"** → [UI.md](UI.md). Generate several radically different UI variations on a single route, switchable via a URL search param and a floating bottom bar.
- **"Build me a quick tool for X"** → [TOOL.md](TOOL.md). A standalone single-file tool that runs on `file://`, no host project, the tool itself is the deliverable.

The three branches produce very different artifacts — getting this wrong wastes the whole effort. If the request is genuinely ambiguous and the user isn't reachable, default to whichever branch better matches the context (a backend module → logic; a page or component → UI; a utility with no host project → tool) and state the assumption at the top of the artifact.

## Rules that apply to all

1. **Throwaway from day one, and clearly marked as such.** The logic and UI branches live inside the host project, next to the code they'll inform — name them so a casual reader sees a prototype, not production, and obey whatever routing and file conventions the project already uses. The tool branch is a standalone `./{slug}/` folder with no host project.
2. **One command to run.** The logic and UI branches use whatever the project's existing task runner supports — `pnpm <name>`, `python <path>`, `bun <path>`, etc. The user must be able to start it without thinking. The tool branch's one command is opening `index.html` (or `npx serve {slug}` when fetch is needed).
3. **No persistence by default.** State lives in memory. Persistence is the thing the prototype is *checking*, not something it should depend on. If the question explicitly involves a database, hit a scratch DB or a local file with a clear "PROTOTYPE — wipe me" name. The tool branch is the exception: its localStorage state is the feature, not a dependency.
4. **Skip the polish.** No tests, no error handling beyond what makes the artifact *runnable*, no abstractions. The point is to learn something fast or serve the job at hand, and then move on.
5. **Surface the state.** After every action (logic) or on every variant switch (UI), print or render the full relevant state so the user can see what changed.
6. **Delete or absorb when done.** When the prototype has answered its question, either delete it or fold the validated decision into the real code — don't leave it rotting in the repo. The tool branch's lifetime is as long as the need for the tool; archive or delete the folder when the need expires.

## When done

The *answer* is the only thing worth keeping from a logic or UI prototype. Capture it somewhere durable (commit message, ADR, issue, or a `NOTES.md` next to the prototype) along with the question it was answering. If the user is around, that capture is a quick conversation; if not, leave the placeholder so they (or you, on the next pass) can fill in the verdict before deleting the prototype. For the tool branch, the artifact itself is the deliverable — SPEC.md's decisions log is the record, and there is nothing to fold back into a codebase.
