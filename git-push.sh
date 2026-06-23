#!/bin/bash
# One-click Git commit and push script (with type selection, UTF-8 safe)

# Remove Windows reserved file 'nul' if exists
[ -f "nul" ] && echo "Warning: removing 'nul' file..." && rm -f "nul"

# Set UTF-8 environment
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Optionally set Git to use UTF-8 for commit messages
git config --local i18n.commitencoding utf-8 >/dev/null 2>&1

# Check if inside Git repo
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "Error: not in a Git repository!"
    read -p "Press any key to exit..." -n1
    exit 1
fi

# Get current branch
branch=$(git symbolic-ref --short HEAD 2>/dev/null)
if [ -z "$branch" ]; then
    echo "Error: detached HEAD state."
    read -p "Press any key to exit..." -n1
    exit 1
fi
echo "Current branch: $branch"

# Check for changes
if git diff --quiet && git diff --cached --quiet && [ -z "$(git ls-files --others --exclude-standard)" ]; then
    echo "No changes to commit."
    read -p "Press any key to exit..." -n1
    exit 0
fi

# Select commit type
echo "Select commit type (enter number):"
echo "  1) feat     - new feature"
echo "  2) fix      - bug fix"
echo "  3) docs     - documentation"
echo "  4) style    - code style (no logic change)"
echo "  5) refactor - refactoring"
echo "  6) perf     - performance improvement"
echo "  7) test     - testing"
echo "  8) chore    - build/tool changes"
echo "  9) no prefix (custom)"
read -p "Enter number (1-9, default 9): " type_choice
[ -z "$type_choice" ] && type_choice=9

case $type_choice in
    1) prefix="feat: " ;;
    2) prefix="fix: " ;;
    3) prefix="docs: " ;;
    4) prefix="style: " ;;
    5) prefix="refactor: " ;;
    6) prefix="perf: " ;;
    7) prefix="test: " ;;
    8) prefix="chore: " ;;
    9) prefix="" ;;
    *) prefix="" ;;
esac

# Input commit description
echo "Enter commit description (you can type Chinese):"
read commit_desc
[ -z "$commit_desc" ] && commit_desc="Update on $(date '+%Y-%m-%d %H:%M:%S')"

commit_message="${prefix}${commit_desc}"
echo "Final commit message: $commit_message"

# Add and commit using a temporary file to avoid encoding issues with command line
tmpfile=$(mktemp)
echo "$commit_message" > "$tmpfile"
git add .
git commit -F "$tmpfile"
commit_status=$?
rm -f "$tmpfile"

if [ $commit_status -ne 0 ]; then
    echo "Commit failed. Please check errors."
    read -p "Press any key to exit..." -n1
    exit 1
fi

# Push
git push origin "$branch"
if [ $? -ne 0 ]; then
    echo "Push failed. Please check network or permissions."
    read -p "Press any key to exit..." -n1
    exit 1
fi

echo "Commit and push successful!"
read -p "Press any key to exit..." -n1