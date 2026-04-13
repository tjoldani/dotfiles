#!/usr/bin/env python3
"""
Weekly Review Agent

Reads last week's Obsidian daily notes, summarizes what happened,
and creates the Monday daily note with a Last Week section pre-filled.

Usage: python3 weekly_review.py
"""

import json
import os
import sys
from datetime import datetime, timedelta
from pathlib import Path

import anthropic

# ---------------------------------------------------------------------------
# Paths
# ---------------------------------------------------------------------------
VAULT = Path("/home/tj/Documents/Home")
DAILY_NOTES = VAULT / "01 Daily"

# ---------------------------------------------------------------------------
# API client
# ---------------------------------------------------------------------------
api_key = os.environ.get("ANTHROPIC_API_KEY")
if not api_key:
    print("Error: ANTHROPIC_API_KEY not set.")
    print("Run: source ~/.secrets")
    sys.exit(1)

client = anthropic.Anthropic(api_key=api_key)

# ---------------------------------------------------------------------------
# Date helpers
# ---------------------------------------------------------------------------
today = datetime.now()
# Last week: previous Monday through Sunday
last_monday = today - timedelta(days=7)
last_sunday = today - timedelta(days=1)

def month_dir(date: datetime) -> str:
    """Returns the month directory name e.g. '04 April'"""
    return date.strftime("%m %B")

def daily_note_path(date: datetime) -> Path:
    """Returns the full path for a given day's note."""
    year = date.strftime("%Y")
    month = month_dir(date)
    filename = date.strftime("%Y%m%d") + f" - {date.strftime('%A')}.md"
    return DAILY_NOTES / year / month / filename

# Monday note for today
monday_note_path = daily_note_path(today)

# The processed Monday template — Templater syntax is not executable here,
# so we reproduce what it renders for a Monday note.
MONDAY_TEMPLATE = """---
tags:
  - Daily
  - Standup
---

## Morning Briefing

{last_week_summary}

---

## What is your focus for the week?

- \n"""

# ---------------------------------------------------------------------------
# Tool definitions
# ---------------------------------------------------------------------------
TOOLS = [
    {
        "name": "list_files",
        "description": "List files in a directory.",
        "input_schema": {
            "type": "object",
            "properties": {
                "directory": {
                    "type": "string",
                    "description": "Absolute path to the directory to list",
                }
            },
            "required": ["directory"],
        },
    },
    {
        "name": "read_file",
        "description": "Read the contents of a file.",
        "input_schema": {
            "type": "object",
            "properties": {
                "path": {
                    "type": "string",
                    "description": "Absolute path to the file to read",
                }
            },
            "required": ["path"],
        },
    },
    {
        "name": "create_monday_note",
        "description": (
            "Create this Monday's daily note with the Last Week summary filled in. "
            "Call this once, after reading all of last week's notes."
        ),
        "input_schema": {
            "type": "object",
            "properties": {
                "last_week_summary": {
                    "type": "string",
                    "description": (
                        "The Last Week summary section content in markdown. "
                        "Use bullet points. Do not include the section header."
                    ),
                }
            },
            "required": ["last_week_summary"],
        },
    },
]

# ---------------------------------------------------------------------------
# Tool execution
# ---------------------------------------------------------------------------
def list_files(directory: str) -> str:
    path = Path(directory)
    if not path.exists():
        return f"Directory not found: {directory}"
    files = sorted(f.name for f in path.iterdir() if f.is_file())
    return "\n".join(files) if files else "No files found."


def read_file(path: str) -> str:
    p = Path(path)
    if not p.exists():
        return f"File not found: {path}"
    content = p.read_text().strip()
    return content if content else "(empty note)"


def create_monday_note(last_week_summary: str) -> str:
    if monday_note_path.exists():
        return f"Note already exists at {monday_note_path} — skipping to avoid overwrite."
    monday_note_path.parent.mkdir(parents=True, exist_ok=True)
    content = MONDAY_TEMPLATE.format(last_week_summary=last_week_summary)
    monday_note_path.write_text(content)
    return f"Monday note created at {monday_note_path}"


def execute_tool(name: str, inputs: dict) -> str:
    if name == "list_files":
        return list_files(**inputs)
    elif name == "read_file":
        return read_file(**inputs)
    elif name == "create_monday_note":
        return create_monday_note(**inputs)
    return f"Unknown tool: {name}"


# ---------------------------------------------------------------------------
# System prompt
# ---------------------------------------------------------------------------

# Build the list of expected daily note paths for the agent's reference
week_paths = []
for i in range(7):
    day = last_monday + timedelta(days=i)
    week_paths.append(str(daily_note_path(day)))

SYSTEM_PROMPT = f"""You are a personal assistant helping summarize last week's work and activities \
from daily notes in an Obsidian vault.

Today is {today.strftime("%A, %B %d, %Y")}.
You are summarizing the week of {last_monday.strftime("%B %d")} – {last_sunday.strftime("%B %d, %Y")}.

## Step 1: Read last week's daily notes
The daily notes for last week should be at these paths (read each one that exists):
{chr(10).join(week_paths)}

If a path doesn't exist, skip it — not every day has a note.

## Step 2: Synthesize a Last Week summary
After reading all available notes, call create_monday_note with a summary.

## What to produce
Read last week's notes to understand what was happening, then write bullets that help the user \
think about the week ahead — not a log of what happened. Each bullet should surface an open \
question, a decision that needs to be made, something unfinished that needs attention, or a \
thread worth pulling on. Think of it as: "given what happened last week, here's what deserves \
your attention this week."

## What to include
- Unfinished work or open loops that need resolution
- Decisions that were deferred or are still pending
- Follow-ups that were promised or expected
- Themes or issues that surfaced and deserve more thought
- Anything that was started but not closed

## What to leave out
- Things that are fully done with no carry-forward
- Raw noise, stray jottings, or fragments without clear meaning
- A play-by-play of what happened — this is not a recap

## Format
Write in bullet points. Be concise and specific — 6–10 bullets is the right length. \
Do not add a header — the template handles that.
When bolding a topic at the start of a bullet, always follow it with a colon, not an em dash. \
Example: **Topic**: description. Never use **Topic** — description."""


# ---------------------------------------------------------------------------
# Agentic loop
# ---------------------------------------------------------------------------
def run_agent():
    print(f"\n{'='*60}")
    print("Weekly Review Agent")
    print(f"Summarizing {last_monday.strftime('%B %d')} – {last_sunday.strftime('%B %d, %Y')}")
    print(f"Writing to: {monday_note_path}")
    print(f"{'='*60}\n")

    messages = [
        {"role": "user", "content": "Summarize last week's daily notes and create this Monday's note."}
    ]

    while True:
        response = client.messages.create(
            model="claude-sonnet-4-6",
            max_tokens=4096,
            system=SYSTEM_PROMPT,
            tools=TOOLS,
            messages=messages,
        )

        for block in response.content:
            if block.type == "text" and block.text.strip():
                print(f"Agent: {block.text}\n")

        tool_calls = [b for b in response.content if b.type == "tool_use"]

        if not tool_calls:
            break

        tool_results = []
        for call in tool_calls:
            print(f"→ {call.name}({json.dumps(call.input)})")
            result = execute_tool(call.name, call.input)
            preview = result[:200].replace("\n", " ") + ("..." if len(result) > 200 else "")
            print(f"  ✓ {preview}\n")

            tool_results.append({
                "type": "tool_result",
                "tool_use_id": call.id,
                "content": result,
            })

        messages.append({"role": "assistant", "content": response.content})
        messages.append({"role": "user", "content": tool_results})

    print("\nDone. Monday note is ready in Obsidian.")


if __name__ == "__main__":
    run_agent()
