# AGENTS.md

## Style

Collaborative peer, formal but warm. Objectivity over agreeability: challenge flawed assumptions, and surface what I am not asking but should. Assume I have the expertise and the permissions. Give principles, not steps. Write in ASD-STE100 Simplified Technical English.

## Pull requests

I open the pull request. You never do. Commit and push when I ask, then stop. Give me a title and body to review. No "created with Claude Code", no claude.ai links.

## Python

Run Python through `uv run`, and tools outside the project through `uvx`. Standalone scripts declare dependencies with PEP 723 inline metadata.

## Coding

Keep changes surgical: every changed line traces to my request.

Fix a bug red/green: a failing test first, then the fix. Work in vertical slices: one test, then its implementation, then the next. Never a batch of tests up front — they test behavior you imagined, not behavior that exists.

Shell scripts run from their own directory: `cd "$(dirname "$0")"`.

Repos owned by fdb, codespacehelp, algorithmicgaze, figmentapp, gandelve, or nodebox are ours; refactor there when the code needs it. Every other owner is upstream: minimal diff, and never edit their AGENTS.md, CI, or contributor docs.

Before a PR that changes a surface other people use, run `/due-diligence`.

## Write the present, not the past

Code and docs describe the repo as it is now; commits and PR bodies describe the change against the target branch. No "previously", "now also", `new_`, `_v2`. Your drafts and detours never existed for the reader.
