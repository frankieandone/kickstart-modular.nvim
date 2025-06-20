#!/usr/bin/env bash
set -e

# Update all submodules to their latest remote commits
echo "Updating all submodules to their latest remote commits..."
git submodule update --remote --merge

# Add submodule references (force, in case of .gitignore)
echo "Staging submodule references..."
git add -f $(git config --file .gitmodules --get-regexp path | awk '{print $2}') 2>/dev/null || true
# Fallback: add all submodules in the repo (for repos without .gitmodules)
for sub in $(git submodule--helper list | awk '{print $4}'); do
    git add -f "$sub"
done

# Commit if there are staged changes
if ! git diff --cached --quiet; then
    git commit -m "chore: update all submodules to latest"
    echo "Committed submodule updates."
    git push
    echo "Pushed to remote."
else
    echo "No submodule updates to commit."
fi 