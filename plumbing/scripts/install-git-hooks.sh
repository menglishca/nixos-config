#!/usr/bin/env bash
set -euo pipefail

# Run from anywhere inside the repo
REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || {
  echo "Not inside a git repo" >&2
  exit 1
})

cd "$REPO_ROOT"

HOOKS_DIR="plumbing/hooks"
GIT_HOOKS_DIR="$REPO_ROOT/.git/hooks"

if [ ! -d "$HOOKS_DIR" ]; then
  echo "No $HOOKS_DIR directory found; nothing to install." >&2
  exit 0
fi

mkdir -p "$GIT_HOOKS_DIR"

# For each executable pre-commit hook in plumbing/hooks, symlink it
for hook in "$HOOKS_DIR"/pre-commit*; do
  [ -e "$hook" ] || continue
  if [ ! -x "$hook" ]; then
    echo "Skipping non-executable hook: $hook" >&2
    continue
  fi

  target="$GIT_HOOKS_DIR/pre-commit"
  echo "Installing pre-commit hook -> $hook"
  ln -sf "$hook" "$target"
done