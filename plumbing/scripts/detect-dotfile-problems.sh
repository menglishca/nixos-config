#!/usr/bin/env bash
set -euo pipefail

# Run from anywhere in the repo
REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || {
  echo "Not inside a git repo" >&2
  exit 1
})

cd "$REPO_ROOT"

# Only run if this looks like your Nix repo
if [ ! -d "modules/home" ]; then
  exit 0
fi

# Find all *.sh under any "dotfiles" dir in modules/home that are not executable
problem_files=$(
  find modules/home -type d -name dotfiles -print0 \
    | while IFS= read -r -d '' d; do
        find "$d" -type f -name '*.sh' ! -perm -u+x -print
      done
)

if [ -n "$problem_files" ]; then
  echo "These .sh files under dotfiles are not executable:"
  echo "$problem_files"
  echo "Run plumbing/scripts/fix-dotfiles.sh to automatically make these files executable"
  exit 1
fi