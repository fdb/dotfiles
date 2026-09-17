---
name: handoff
description: Carry the knowledge of this session into a new one. Writes HANDOFF.md with the goal, the observed state, the decisions, the dead ends, and the next step, then gives the prompt that starts the new session. Use when the user says "handoff" or "hand off", before a compaction, when the context is long, when work stops for the day, or when another session or agent continues the work.
---

# Handoff

A new session knows the repo and nothing else. It does not know what you tried, what failed, what the user decided, or which of your beliefs you checked. A summary of the conversation does not help it; a briefing does. Write for a capable colleague who starts cold and has ten minutes.

## Sort the knowledge first

Session knowledge is of two kinds. Separate them before you write.

- **Durable**: true for as long as the repo exists. The command that flashes the device, the port the dev server uses, the base branch, a trap in a dependency. Put these in the repo's AGENTS.md, in terse lines, and point to the place where the detail lives. Do not copy them into the handoff.
- **Transient**: true for this piece of work. This goes into `HANDOFF.md`.

If the user keeps another convention in this repo (`FINDINGS.md`, `PLAN.md`), follow it and do not add a second file.

## Write HANDOFF.md

Put it in the repo root, or the worktree root. Use these sections, and leave out a section that has nothing in it.

1. **Goal.** What the user wants, in their terms, and the stopping condition: the observation that shows it is done.
2. **State.** Three lists: done and observed (with the evidence: test name, commit hash, URL, screenshot path); changed but not verified; not started. Give the branch, the last commit, and any uncommitted or unpushed work.
3. **Decisions.** What the user decided and why, with their words where the wording matters. Include constraints the user gave along the way ("do not touch the .kicad_pcb", "base is rewrite-in-rust"). The next session must not ask again, and must not undo them.
4. **Dead ends.** What was tried and failed, and the evidence that it failed. This section saves the most time; do not shorten it to be polite about your own errors.
5. **Facts.** What you learned about the system and the environment that the work depends on. Mark each as *observed* or *assumed*.
6. **Open questions.** What only the user can answer.
7. **Next step.** The one action to take first, and how to verify it.

Rules:

- Write the present state, not the story of the session.
- Give paths, commands, and identifiers exactly; the reader will paste them.
- No secrets and no personal data. Refer to the 1Password item or the file, not the value.
- Keep it under two screens. If it grows longer, the durable part is still in it.

## Check it

Read `HANDOFF.md` one time as the new session: with only this file and the repo, can you take the next step? Every path and command in it must exist; run `ls` or `git` on them to be sure.

## Hand over

Do not stage or commit `HANDOFF.md` unless the user asks. Tell the user where the file is, list any lines that you added to AGENTS.md, and give the prompt for the new session:

```
Read HANDOFF.md, check its State section against git, then continue with its Next step.
```

## When you receive a handoff

Verify the State section against the repo before you trust it: branch, last commit, uncommitted work. Treat *assumed* facts as open. When the work is complete, move any remaining durable knowledge to AGENTS.md and delete `HANDOFF.md`.
