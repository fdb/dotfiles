---
name: catch-up
description: Bring the user back up to speed on what an agent did in a session. Reads the session log, lists the decisions with who took each one (the user, the agent with approval, or the agent alone), explains the terms the agent introduced, and then goes one level deeper on whatever the user points at. Use when the user says "catch up", "catch me up", "what did you do", "what did we decide", "I lost track", "I never decided that", or returns to a session after time away. Arguments - nothing for the running session, a session id for another one, `repo [date]` for all sessions in this project since a date.
---

# Catch-up

The user has lost the thread of a session. The agent kept working, took decisions, and started using names the user has never seen, sometimes while saying that the user chose them. Your job is to give the user their understanding back, at the speed they set. You explain and you report; you change no files and continue no work.

Work from the session log and not from your memory of the session. Your memory is what is in doubt here, and after a compaction it is a summary written by the agent whose account is being checked.

## Read the log

`scripts/transcript.py` (next to this file) prints a log as numbered turns. It drops tool output and thinking.

```
uv run scripts/transcript.py --user             # only the user's turns; read this first
uv run scripts/transcript.py                    # overview of every turn
uv run scripts/transcript.py --turn 6 14        # these turns in full, with every tool call
uv run scripts/transcript.py --who outbox _FP   # who used a word first, and in which turns
uv run scripts/transcript.py <id or prefix> …   # another session; default is the running one
uv run scripts/transcript.py --list --since 2026-10-01   # sessions of this project
```

Read in that order. The user's turns are short and tell you what was asked and where the user pushed back. The overview shortens each agent turn to its opening and its closing report, counts the routine tool calls, and prints commits, pushes, and question dialogs with their options. A long command is printed with its start and its end, so a commit's trailer lines are visible. An option the agent recommended has "(Recommended)" in its label; no such label means none was recommended. The overview leaves out the middle of long agent turns, and corrections are often there, so search for them with `--who` and words like "wrong", "invalid", "correction", "actually", "turns out". Before you quote a turn or attribute a decision to it, read it with `--turn`.

These turn labels are the user acting: `USER`, `USER (typed while the agent worked)`, `USER answered …`, `USER refused …`, `USER command`. A message typed while the agent worked sits in the log at the point where it arrived, so the agent turn printed before it shows what had already been done by then.

The header gives the directory the session started in; use that path when you open files, and if it no longer exists the repo was moved or renamed, so ask where it is. It also names the folder of subagent logs if there is one. Read those when a decision was taken inside a subagent.

For `repo`, list the sessions, read each, and put the session id prefix before every turn number.

## Find the decisions

A decision is a point where the work could have gone another way and the choice still shapes the code or the plan: a library, a data format, a file layout, a name that many things now depend on, a scope cut, something deliberately left out, a default. A step that any competent person would have taken the same way is not a decision. Expect five to ten in a long session. If you have twenty, you are listing steps.

For each decision, find the turn where it entered the session and give it an origin:

- **you said**: the user stated it. Give the turn.
- **you approved**: the agent proposed it and the user agreed in a later turn or picked it in a question dialog. Give both turns. If the picked option was the one marked "Recommended", say so, because the user may not remember a choice they clicked through.
- **agent, announced**: the agent chose it and said so with a reason, and no user turn accepts it. A user message that follows without objecting is not approval; the user may not have read that far.
- **agent, unannounced**: the agent did it and never presented it as a choice. You find these in the tool calls and the closing reports.

If the user stated a preference and the agent went another way, say that in the line ("you suggested 8 or 10; the agent took 100"), whatever the origin.

Never write that the user decided something unless one of the user's turns shows it. If the agent wrote "as you asked" or "per your decision" and no user turn supports it, report that mismatch as a finding, with both turn numbers. If the agent refers to something the user did in another session, you cannot check it from this log; say so, and offer to look for that session with `--list`.

Record the reason the agent gave and the alternatives it named. If the log gives no reason, write "no reason given". Do not supply one.

## Find the other things a returning user needs

Three kinds of finding are not decisions and matter as much:

- **Claims the agent withdrew.** The agent said something was fixed, measured, or true, and later took it back or contradicted it. Give both turns. If a decision was taken between the two, check whether it rested on the withdrawn claim.
- **Offers nobody answered.** The agent proposed something, asked "want me to?", and the session moved on. These are open, and the user may think they were done or dropped.
- **Actions outside the user's rules.** Read the AGENTS.md or CLAUDE.md of the session's project and the user's global one, then check the commits, pushes, pull requests, deploys, and messages in the log against them: was each one asked for, and does its content follow the rules (for example on attribution lines)? The rules may be newer than the session, so report "this does not match your current rule" and not "the agent broke a rule".

## Predict the hard parts

Before you write, work out where this user will get stuck. Find the candidates by reading; the vocabulary of the user's own turns tells you what they already know. Then confirm each one with `--who`, which shows whether the user ever wrote the word.

1. A name the agent introduced that a decision depends on, and that the user never wrote. Include plain words used in a special sense ("movers", "wedged"), which are easier to miss than identifiers.
2. A decision whose reason rests on background the user's messages do not show.
3. One thing with two names: the user says "pillars", the agent and the code say "branches".

Explain these in the first pass without being asked. Explain each one by what it does in this project ("the outbox is the table where a message waits until the mail server has accepted it") and not by its textbook definition. Where an explanation is the agent's theory and was never measured or tested, say that.

## The first pass

It has to fit on one screen, about forty terminal lines, because the user asked for this while overloaded. An item takes one or two terminal lines. For an agent decision that is the decision, the user's stated preference if there was one, and the cost to reverse; the agent's reason and the alternatives wait for level 2.

1. **Where things stand**, in two or three sentences: what the session set out to do, what exists now, what the agent is in the middle of.
2. **Needs your attention**, numbered: decisions with origin *agent*, withdrawn claims that something still rests on, and actions outside the rules. For a decision, add what it would cost to reverse now (a rename, a rewrite of one module, a data migration) and ask keep or revisit.
3. **Decisions you took or approved**, numbering continued, with origin and turn.
4. **Left open**: unanswered offers, in one line together if they are small.
5. **Terms**, lettered.
6. **Where to go deeper**: two or three items you expect to be worth opening, each with a few words on what is inside ("3: why SQLite and not Postgres, and what that rules out later").

Quote the user's words only where the wording settles something or where the user is likely to doubt the attribution; elsewhere the turn number is enough.

When it does not fit, cut in this order: terms that no listed decision depends on; decisions the user took themselves and will remember; announced agent decisions that are cheap to reverse. Say in one line what you left out ("four smaller decisions not shown; ask for the full list"). Never cut an item from "Needs your attention" to save space.

Keep the numbers and letters stable for the rest of the conversation, so the user can answer `3` or `b`.

## Going deeper

When the user points at an item, or says some part is unclear, go down one level on that part only, and then stop. The levels:

1. The one line from the first pass.
2. The reasoning: why this, what else was considered, what it depends on and what depends on it. Reread the source turns with `--turn` first.
3. The mechanism: how it works in this codebase. Open the files and show the lines. A short piece of real code with an explanation is better than a description of it.
4. The background: the general concept underneath, taught from the beginning, for a reader who has not met it.

The user chooses the direction. "Why" moves toward reasoning, "how" toward mechanism, "what is" toward background. A vague "this is unclear" means the level you just gave assumed something; find the assumption and explain that, and do not repeat the same explanation with more words.

There is no floor. If the fourth level uses a term the user does not know, explain that term, and keep going for as long as they keep asking. Each answer ends with one or two things that can be opened from here, so the user never has to work out what to ask.

When the log and the code disagree (the agent said it did something and the file does not show it), say so.

## Decisions the user wants back

When the user says "revisit" for a decision, do not act on it here. Write down what they want changed, and at the end give the list as a short message they can hand to the working session. If you are the working session, ask before you resume work, and start with that list.

## Limits to state

- The log shows what was said and which tools were called. It does not show tool output, so "the tests passed" in the agent's words is a claim. Check when the user's question depends on it, with anything that only reads (the files, `git log`, `gh pr view`), and say which statements you checked.
- Mark your own inferences as inferences. "The agent gave no reason; my reading is that …"
- Logs can contain secrets and personal data that were pasted into the session. Do not copy those into the catch-up.
