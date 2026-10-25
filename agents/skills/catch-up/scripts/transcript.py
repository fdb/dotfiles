#!/usr/bin/env -S uv run
# /// script
# requires-python = ">=3.11"
# dependencies = []
# ///
"""Print a Claude Code session log as a short, numbered list of turns.

Keeps what the user said, what the assistant said, which tools it called, and
the user's answers to questions and plans. Drops tool output and thinking.
"""

import argparse
import json
import os
import re
import sys
from collections import Counter
from datetime import datetime
from pathlib import Path

PROJECTS = Path.home() / ".claude" / "projects"

# Tool results that carry a decision by the user.
ANSWER_TOOLS = {"AskUserQuestion", "ExitPlanMode"}
REJECTION = re.compile(r"user (doesn't|does not) want|rejected|interrupted by user", re.I)
REMINDER = re.compile(r"<system-reminder>.*?</system-reminder>", re.S)
COMMAND = re.compile(r"<command-name>(.*?)</command-name>(?:.*?<command-args>(.*?)</command-args>)?", re.S)
# Text in a user record that the harness wrote.
HARNESS = ("<local-command-", "<task-notification>", "<bash-stdout>", "<bash-stderr>")
# Shell commands that are shown in full in the overview.
CONSEQUENTIAL = re.compile(r"\bgit (commit|push|merge|rebase|reset|revert|tag)\b|\bgh (pr|issue|release)\b|\b(publish|deploy)\b")
# The argument that says most about a tool call, first match wins.
KEY_ARGS = ("file_path", "path", "command", "description", "prompt", "skill", "url", "query", "pattern")


def project_dir(cwd: Path) -> Path:
    return PROJECTS / re.sub(r"[^A-Za-z0-9]", "-", str(cwd))


def find_session(ref: str | None) -> Path:
    if ref and Path(ref).is_file():
        return Path(ref)
    session_id = ref or os.environ.get("CLAUDE_CODE_SESSION_ID")
    if session_id:
        matches = sorted(PROJECTS.glob(f"*/{session_id}*.jsonl"))
        if matches:
            return matches[0]
        if ref:
            sys.exit(f"no session log matches {ref}")
    logs = sorted(project_dir(Path.cwd()).glob("*.jsonl"), key=lambda p: p.stat().st_mtime)
    if not logs:
        sys.exit(f"no session logs in {project_dir(Path.cwd())}")
    return logs[-1]


def records(path: Path):
    with path.open() as f:
        for line in f:
            try:
                yield json.loads(line)
            except json.JSONDecodeError:
                continue


def clock(record: dict) -> str:
    stamp = record.get("timestamp")
    if not stamp:
        return ""
    return datetime.fromisoformat(stamp.replace("Z", "+00:00")).astimezone().strftime("%Y-%m-%d %H:%M")


def block_text(content) -> str:
    if isinstance(content, str):
        return content
    if isinstance(content, list):
        return "\n".join(b.get("text", "") for b in content if isinstance(b, dict) and b.get("type") == "text")
    return ""


def tool_call(block: dict) -> dict:
    args = block.get("input") or {}
    name = block.get("name", "")
    detail = next((" ".join(str(args[k]).split()) for k in KEY_ARGS if args.get(k)), "")
    if name == "AskUserQuestion":
        asked = []
        for q in args.get("questions") or []:
            options = " | ".join(o.get("label", "") for o in q.get("options") or [])
            asked.append(f"{q.get('question', '')} [{options}]")
        detail = " ; ".join(asked)
    elif name == "ExitPlanMode":
        detail = str(args.get("plan", ""))
    return {"name": name, "detail": detail, "file": args.get("file_path", "")}


def user_entries(text: str, when: str, typed_during_work: bool = False) -> list[dict]:
    text = REMINDER.sub("", text).strip()
    if not text or text.startswith(HARNESS):
        return []
    command = COMMAND.search(text)
    if command:
        line = " ".join(part for part in command.groups() if part).strip()
        return [{"who": "USER command", "when": when, "items": [("text", line)]}]
    who = "USER (typed while the agent worked)" if typed_during_work else "USER"
    return [{"who": who, "when": when, "items": [("text", text)]}]


def turns(path: Path) -> list[dict]:
    """One entry per turn: who, when, and its texts and tool calls in order."""
    out: list[dict] = []
    tool_names: dict[str, str] = {}
    for r in records(path):
        kind = r.get("type")
        when = clock(r)
        if r.get("isSidechain"):
            continue
        if kind == "attachment":
            # A message typed while the agent was working is stored here.
            queued = r.get("attachment") or {}
            if queued.get("type") == "queued_command" and queued.get("commandMode") == "prompt":
                out += user_entries(str(queued.get("prompt", "")), when, typed_during_work=True)
            continue
        if kind not in ("user", "assistant"):
            continue
        content = (r.get("message") or {}).get("content")
        blocks = content if isinstance(content, list) else []
        if kind == "assistant":
            items = []
            for b in blocks:
                if not isinstance(b, dict):
                    continue
                if b.get("type") == "text" and b.get("text", "").strip():
                    items.append(("text", b["text"].strip()))
                elif b.get("type") == "tool_use":
                    tool_names[b.get("id", "")] = b.get("name", "")
                    items.append(("tool", tool_call(b)))
            if not items:
                continue
            # Consecutive assistant records are one turn of work.
            if out and out[-1]["who"] == "AI":
                out[-1]["items"] += items
            else:
                out.append({"who": "AI", "when": when, "items": items})
            continue
        if r.get("isCompactSummary"):
            out.append({"who": "COMPACTION", "when": when, "items": [("text", block_text(content).strip())]})
            continue
        if r.get("isMeta"):
            continue
        for b in blocks:
            if not isinstance(b, dict) or b.get("type") != "tool_result":
                continue
            name = tool_names.get(b.get("tool_use_id", ""), "") or "a tool call"
            result = block_text(b.get("content")).strip()
            if name in ANSWER_TOOLS:
                out.append({"who": f"USER answered {name}", "when": when, "items": [("text", result)]})
            elif b.get("is_error") and REJECTION.search(result):
                out.append({"who": f"USER refused {name}", "when": when, "items": [("text", result)]})
        out += user_entries(block_text(content), when)
    return out


def text_of(turn: dict, with_tools: bool = False) -> str:
    parts = []
    for kind, value in turn["items"]:
        if kind == "text":
            parts.append(value)
        elif with_tools:
            parts.append(value["detail"])
    return "\n".join(parts)


def header(path: Path) -> dict:
    found = {"title": "", "cwd": ""}
    for r in records(path):
        if r.get("type") == "ai-title":
            found["title"] = r.get("aiTitle", "")
        if r.get("cwd") and not found["cwd"]:
            found["cwd"] = r["cwd"]
    return found


def clip(text: str, head: int, tail: int) -> str:
    """Shorten the middle. An agent's turn ends with what it did, so the tail is kept longer."""
    if len(text) <= head + tail:
        return text
    ending = text[-tail:] if tail else ""
    return f"{text[:head]}\n[... {len(text) - head - tail} characters left out, see --turn ...]\n{ending}"


def tool_detail(call: dict, head: int, tail: int) -> str:
    """A question is printed whole; a long command keeps its end, where a commit's trailer is."""
    detail = call["detail"]
    if call["name"] in ANSWER_TOOLS or len(detail) <= head + tail:
        return detail
    return f"{detail[:head]} [... {len(detail) - head - tail} characters ...] {detail[-tail:]}"


def print_overview_turn(turn: dict) -> None:
    text = text_of(turn)
    if turn["who"] == "AI":
        text = clip(text, 250, 900)
    elif turn["who"] == "COMPACTION":
        text = clip(text, 300, 0)
    else:
        # The user's words are the evidence, so they are kept nearly whole.
        text = clip(text, 3000, 500)
    if text:
        print(text)
    calls = [value for kind, value in turn["items"] if kind == "tool"]
    if not calls:
        return
    counts = Counter(c["name"] for c in calls)
    print("  > tools: " + ", ".join(f"{name} x{n}" for name, n in counts.most_common()))
    written = Counter(c["file"] for c in calls if c["name"] in ("Write", "Edit", "NotebookEdit") and c["file"])
    if written:
        print("  > files changed: " + ", ".join(f"{file} x{n}" for file, n in written.most_common()))
    for c in calls:
        if c["name"] in ANSWER_TOOLS or (c["name"] == "Bash" and CONSEQUENTIAL.search(c["detail"])):
            print(f"  > {c['name']}: {tool_detail(c, 160, 140)}")


def print_full_turn(turn: dict) -> None:
    for kind, value in turn["items"]:
        if kind == "text":
            print(value)
        else:
            print(f"  > {value['name']}: {tool_detail(value, 300, 300)}")


def show(path: Path, only: list[int] | None, full: bool, user_only: bool) -> None:
    entries = turns(path)
    info = header(path)
    span = f"{entries[0]['when']} to {entries[-1]['when']}" if entries else ""
    subagents = path.with_suffix("") / "subagents"
    print(f"# session {path.stem}  \"{info['title']}\"")
    print(f"# {len(entries)} turns, {span}, started in {info['cwd']}")
    print(f"# log: {path}")
    if subagents.is_dir():
        print(f"# subagent logs: {subagents} ({len(list(subagents.glob('*.jsonl')))} files)")
    for n, turn in enumerate(entries, 1):
        if only and n not in only:
            continue
        if user_only and not turn["who"].startswith("USER"):
            continue
        print(f"\n[{n}] {turn['who']}  {turn['when']}")
        if full or only:
            print_full_turn(turn)
        else:
            print_overview_turn(turn)


def who_said(path: Path, words: list[str]) -> None:
    """For each word: who used it first, and in which turns each side used it."""
    entries = turns(path)
    for word in words:
        needle = word.lower()
        by_user = [n for n, t in enumerate(entries, 1) if t["who"].startswith("USER") and needle in text_of(t).lower()]
        # A commit message or a file path is the agent's wording too.
        by_agent = [n for n, t in enumerate(entries, 1) if t["who"] == "AI" and needle in text_of(t, with_tools=True).lower()]
        if not by_user and not by_agent:
            print(f"{word}: not in the log")
            continue
        first = min(by_user + by_agent)
        print(f"{word}: first in [{first}] by {entries[first - 1]['who']}; user turns {by_user or 'none'}; agent turns {by_agent or 'none'}")


def listing(since: str | None) -> None:
    # The shell may have moved into a subdirectory; the running session's log
    # still sits in the folder of the directory the session started in.
    running = sorted(PROJECTS.glob(f"*/{os.environ.get('CLAUDE_CODE_SESSION_ID', '-')}.jsonl"))
    folder = running[0].parent if running else project_dir(Path.cwd())
    for path in sorted(folder.glob("*.jsonl"), key=lambda p: p.stat().st_mtime):
        modified = datetime.fromtimestamp(path.stat().st_mtime)
        if since and modified < datetime.fromisoformat(since):
            continue
        print(f"{modified:%Y-%m-%d %H:%M}  {path.stem}  {path.stat().st_size // 1024:6d} KB  {header(path)['title']}")


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("session", nargs="?", help="session id, id prefix, or path; default is the running session")
    parser.add_argument("--list", action="store_true", help="list the sessions of this project")
    parser.add_argument("--since", help="with --list, only sessions modified on or after this date (YYYY-MM-DD)")
    parser.add_argument("--user", action="store_true", help="print only the user's turns")
    parser.add_argument("--turn", type=int, nargs="+", help="print these turns in full, in order, with every tool call")
    parser.add_argument("--full", action="store_true", help="print every turn in full")
    parser.add_argument("--who", nargs="+", metavar="WORD", help="for each word, who used it first and in which turns")
    args = parser.parse_args()

    if args.list:
        listing(args.since)
        return
    path = find_session(args.session)
    if args.who:
        who_said(path, args.who)
    else:
        show(path, args.turn, args.full, args.user)


if __name__ == "__main__":
    try:
        main()
    except BrokenPipeError:
        # The reader (head, a pager) closed early.
        sys.stderr.close()
