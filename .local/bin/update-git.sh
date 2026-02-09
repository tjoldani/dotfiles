#!/bin/bash

git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" add -A
git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" commit -m "Auto-update dotfiles $(date +'%Y-%m-%d')" || echo "No changes to commit"
git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" push origin master || echo "Push failed"
