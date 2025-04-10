#!/bin/bash

# Base folder
base="$HOME/Obsidian/Home/01 Daily"

# Date parts
year=$(date +%Y)
month_num=$(date +%m)
month_name=$(date +%B)
day=$(date +%d)
weekday=$(date +%A)
today=$(date +%Y%m%d)

# Folder and file path
folder="$base/$year/$month_num $month_name"
file="$folder/$today - $weekday.md"

# Create folder if needed
mkdir -p "$folder"

# Create the file if it doesn't exist
if [ ! -f "$file" ]; then
  {
    echo "---"
    echo "tags:"
    echo "- Daily"

    if [ "$weekday" = "Monday" ]; then
      echo "- Standup"
    elif [ "$weekday" = "Friday" ]; then
      echo "- Reflection"
    fi

    echo "---"
    echo ""

    if [ "$weekday" = "Monday" ]; then
      echo "# What is your focus for the week?"
      echo "- "
      echo ""
      echo "---"
    elif [ "$weekday" = "Friday" ]; then
      echo "# What went well this week?"
      echo "- "
      echo "# What is your focus for next week?"
      echo "- "
      echo "# What articles did you find interesting?"
      echo "* "
      echo "# How can you improve/change?"
      echo "- "
      echo "---"
    fi

    echo ""
  } > "$file"
fi

# Open in kitty as floating window
kitty --class dailynote nvim "$file"
