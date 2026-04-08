#!/usr/bin/env bash
set -euo pipefail

# Run from repo root
cd "$(git rev-parse --show-toplevel)"

find modules/home -type d -name dotfiles -print0 \
  | while IFS= read -r -d '' d; do
      echo "Fixing .sh files in: $d"
      find "$d" -type f -name "*.sh" ! -perm -u+x -print -exec chmod +x {} \;
    done
