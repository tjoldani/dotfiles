#!/bin/bash

# Function to sync a standard Git repo
sync_repo() {
    local repo_path="$1"
    local repo_name="$2"

    if [ ! -d "$repo_path" ]; then
        echo "Failed to access $repo_path – Skipping $repo_name"
        return 1
    fi

    cd "$repo_path" || return 1
    git add .
    git commit -m "Auto-update $repo_name $(date +'%Y-%m-%d')" || echo "No changes to commit in $repo_name"
    git push origin main || echo "Push failed for $repo_name"
    echo "$repo_name sync complete!"
}

# Function to sync your bare dotfiles repo
sync_dotfiles() {
    echo "Syncing dotfiles..."

    git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" add -A
    git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" commit -m "Auto-update dotfiles $(date +'%Y-%m-%d')" || echo "No changes to commit in dotfiles"
    git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" push origin master || echo "Push failed for dotfiles"
    echo "dotfiles sync complete!"
}

# Run syncs
sync_dotfiles
sync_repo "/mnt/ha" "Home Assistant"

echo "All repositories processed!"

