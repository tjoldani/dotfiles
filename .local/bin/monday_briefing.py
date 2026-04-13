#!/usr/bin/env python3
"""
Monday Morning Briefing Agent

An agentic loop that reads the week's mobility monitor output and produces
a CX-focused briefing note in the Obsidian inbox.

Usage: python3 monday_briefing.py
"""

import json
import os
import sys
from datetime import datetime, timedelta
from pathlib import Path

import anthropic
import requests
import subprocess

# ---------------------------------------------------------------------------
# Paths
# ---------------------------------------------------------------------------
MONITOR_OUTPUT = Path("/mnt/server/mobility-monitor/output")
OBSIDIAN_INBOX = Path("/home/tj/Documents/Home/00 Inbox")
GITHUB_OUTPUT = Path("/mnt/server/mobility-monitor/output")

# ---------------------------------------------------------------------------
# API client
#
# Reads the key from the environment. To set it, run:
#   export ANTHROPIC_API_KEY="sk-ant-..."
# The key lives in /mnt/server/mobility-monitor/config.yaml if you need it.
# ---------------------------------------------------------------------------
api_key = os.environ.get("ANTHROPIC_API_KEY")
if not api_key:
    print("Error: ANTHROPIC_API_KEY not set.")
    print("Run: export ANTHROPIC_API_KEY='your-key-here'")
    print("Key is in /mnt/server/mobility-monitor/config.yaml")
    sys.exit(1)

client = anthropic.Anthropic(api_key=api_key)

TELEGRAM_TOKEN = os.environ.get("TELEGRAM_BOT_TOKEN")
TELEGRAM_CHAT_ID = os.environ.get("TELEGRAM_CHAT_ID")

# ---------------------------------------------------------------------------
# Tool definitions
#
# This is what Claude sees. Each tool has a name, a description (Claude reads
# this to decide when to use it), and an input_schema describing the parameters.
# Claude does NOT see the Python functions below — only these definitions.
# ---------------------------------------------------------------------------
TOOLS = [
    {
        "name": "list_files",
        "description": (
            "List files in a directory. Use this to find the week's "
            "mobility monitor output files."
        ),
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
        "description": "Read the full contents of a file.",
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
        "name": "write_briefing",
        "description": (
            "Write the finished Monday briefing note to the Obsidian inbox. "
            "Call this once, after reading all the relevant files."
        ),
        "input_schema": {
            "type": "object",
            "properties": {
                "content": {
                    "type": "string",
                    "description": "The full markdown content of the briefing note",
                }
            },
            "required": ["content"],
        },
    },
]

# ---------------------------------------------------------------------------
# Tool execution
#
# These are the actual Python functions that run when Claude calls a tool.
# The agentic loop matches tool names to these functions and returns results.
# ---------------------------------------------------------------------------
def list_files(directory: str) -> str:
    path = Path(directory)
    if not path.exists():
        return f"Directory not found: {directory}"
    files = sorted(f.name for f in path.iterdir() if f.is_file())
    return "\n".join(files)


def read_file(path: str) -> str:
    p = Path(path)
    if not p.exists():
        return f"File not found: {path}"
    return p.read_text()


def send_to_telegram(content: str):
    """Send briefing to Telegram group, splitting if over the 4096 char limit."""
    if not TELEGRAM_TOKEN or not TELEGRAM_CHAT_ID:
        print("Telegram credentials not set — skipping Telegram send")
        return

    api_url = f"https://api.telegram.org/bot{TELEGRAM_TOKEN}/sendMessage"

    # Split at double newlines to avoid cutting mid-sentence
    chunks = []
    current = ""
    for paragraph in content.split("\n\n"):
        if len(current) + len(paragraph) + 2 > 4096:
            if current:
                chunks.append(current.strip())
            current = paragraph
        else:
            current = (current + "\n\n" + paragraph) if current else paragraph
    if current:
        chunks.append(current.strip())

    for chunk in chunks:
        try:
            requests.post(api_url, json={
                "chat_id": TELEGRAM_CHAT_ID,
                "text": chunk,
                "parse_mode": "Markdown"
            }, timeout=10)
        except Exception as e:
            print(f"Telegram send error: {e}")


def push_to_github(filepath: Path, filename: str):
    """Commit and push the briefing file to the mobility monitor GitHub repo."""
    repo = GITHUB_OUTPUT
    try:
        subprocess.run(["git", "-C", str(repo), "add", filename], check=True)
        subprocess.run(["git", "-C", str(repo), "commit", "-m", f"Monday briefing {filename}"], check=True)
        subprocess.run(["git", "-C", str(repo), "push"], check=True)
        print(f"Pushed {filename} to GitHub")
    except subprocess.CalledProcessError as e:
        print(f"GitHub push failed: {e}")


def write_briefing(content: str) -> str:
    today = datetime.now()
    filename = f"{today.strftime('%Y%m%d')}-Monday-Briefing.md"

    # Write to Obsidian inbox
    obsidian_filename = f"{today.strftime('%Y%m%d')} - Monday Briefing.md"
    obsidian_path = OBSIDIAN_INBOX / obsidian_filename
    obsidian_path.write_text(content)

    # Write to GitHub repo
    github_path = GITHUB_OUTPUT / filename
    github_path.write_text(content)
    push_to_github(github_path, filename)

    # Send to Telegram
    send_to_telegram(content)

    return f"Briefing written to Obsidian, GitHub, and Telegram"


def execute_tool(name: str, inputs: dict) -> str:
    if name == "list_files":
        return list_files(**inputs)
    elif name == "read_file":
        return read_file(**inputs)
    elif name == "write_briefing":
        return write_briefing(**inputs)
    return f"Unknown tool: {name}"


# ---------------------------------------------------------------------------
# System prompt
#
# This is the agent's editorial brain. It tells Claude what to care about,
# what to cut, and exactly what the output should look like. The more specific
# this is, the better the output — vague prompts produce vague briefings.
# ---------------------------------------------------------------------------
today = datetime.now()
# Always look at the previous full Mon–Sun week
last_monday = today - timedelta(days=7)
last_sunday = today - timedelta(days=1)

SYSTEM_PROMPT = f"""You are a strategic industry analyst producing a Monday morning briefing \
for a senior professional in the rental car and mobility industry.

Today is {today.strftime("%A, %B %d, %Y")}.
You are looking for daily output files covering the full week of \
{last_monday.strftime("%B %d")} – {last_sunday.strftime("%B %d, %Y")} (Monday through Sunday).

## Step 1: Find this week's files
List the directory: {MONITOR_OUTPUT}
Identify daily files from the past week. File names follow the pattern YYYYMMDD-Day.md \
(e.g. 20260407-Tue.md). Include all seven days if files exist. Skip any files ending in \
-EOW or with a number suffix like -1, -2 as these are duplicates or deprecated.

## Step 2: Read each file
Read the daily files for the full Monday through Sunday of the target week.

## Step 3: Write the briefing
Call write_briefing with the finished note once you have read all the relevant files.

---

## What to prioritize
Focus on stories that signal where customer experience in travel and transportation is heading:
- Self-service technology: kiosks, mobile check-in/out, app features, digital keys
- New products or features launched by travel companies (airlines, hotels, rental car, rideshare)
- Loyalty program changes and personalization strategies
- Retail CX innovation with clear parallels in travel (frictionless checkout, subscription models, etc.)
- Competitor moves that reveal strategic direction around customer experience
- AI being applied directly to customer-facing interactions

## What to cut
Not everything in the daily files deserves Monday attention. Cut:
- Pure EV specs and battery chemistry (unless tied to a customer experience change)
- Stock prices and earnings beats (unless they reveal a strategic CX shift)
- Executive appointments (unless the hire signals a specific direction)
- Regulatory and policy news (unless it directly changes the customer experience)
- Minor operational items with no strategic signal

## Output format
Write the briefing in markdown using this exact structure:

---
tags:
  - Briefing
  - Mobility
---

# Monday Briefing — Week of {last_monday.strftime("%B %d, %Y")}

## What's Happening
[4–6 stories that matter. For each one:]
**[Bold headline]**
[2–3 sentences: what happened, who did it, why it's significant in context.]
*Implication: [One sentence on what this means for rental car or travel CX broadly.]*

## What to Consider
[3–5 forward-looking questions or action items this week's news raises. Be specific. \
These should prompt thinking, not restate the news.]

---

Make editorial decisions. Quality over completeness. This is a briefing, not a recap."""


# ---------------------------------------------------------------------------
# Agentic loop
#
# This is the core of the agent pattern:
# 1. Send a message to Claude with the tools available
# 2. Claude responds — either with tool calls or a final answer
# 3. If tool calls: execute them, add results to the conversation, repeat
# 4. If no tool calls (stop_reason == "end_turn"): we're done
#
# The message history grows with each turn — Claude sees the full context
# of everything it has read and done so far.
# ---------------------------------------------------------------------------
def run_agent():
    print(f"\n{'='*60}")
    print("Monday Briefing Agent")
    print(f"Week of {last_monday.strftime('%B %d')} – {last_sunday.strftime('%B %d, %Y')}")
    print(f"{'='*60}\n")

    messages = [
        {"role": "user", "content": "Generate this week's Monday morning briefing."}
    ]

    turn = 0
    while True:
        turn += 1
        response = client.messages.create(
            model="claude-sonnet-4-6",
            max_tokens=4096,
            system=SYSTEM_PROMPT,
            tools=TOOLS,
            messages=messages,
        )

        # Print any text Claude produces (reasoning, commentary)
        for block in response.content:
            if block.type == "text" and block.text.strip():
                print(f"Agent: {block.text}\n")

        # Collect tool calls from this response
        tool_calls = [b for b in response.content if b.type == "tool_use"]

        # No tool calls means Claude is done
        if not tool_calls:
            break

        # Execute each tool and collect results
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

        # Append this turn to the message history and loop
        messages.append({"role": "assistant", "content": response.content})
        messages.append({"role": "user", "content": tool_results})

    print("\nDone. Check your Obsidian inbox.")


if __name__ == "__main__":
    run_agent()
