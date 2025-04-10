#!/bin/bash

inbox="$HOME/Obsidian/Home/00 Inbox/"
timestamp=$(date +"%Y%m%d-%H%M%S")
filename="$inbox/${timestamp}.md"

kitty --class newnote nvim "$filename"
