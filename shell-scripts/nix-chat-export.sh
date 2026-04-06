#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  nix-chat-export.sh [repo_path] [options]

Options:
  -o, --output FILE       Write to FILE instead of stdout
  -n, --no-gitignore      Include files normally ignored by .gitignore
  -H, --hidden            Include hidden files
  -s, --sort              Sort paths
  --max-bytes N           Skip files larger than N bytes (default: 200000)
  --include PATTERN       Add include glob, repeatable (example: --include '*.nix')
  --exclude PATTERN       Add exclude glob, repeatable (example: --exclude 'result')
  -h, --help              Show this help

Examples:
  nix-chat-export.sh ~/src/nixos-config > chat.txt
  nix-chat-export.sh . --include '*.nix' --include '*.sh'
  nix-chat-export.sh . -o prompt-pack.txt --exclude 'secrets/**'
EOF
}

repo="."
output=""
no_gitignore=0
include_hidden=0
sort_paths=0
max_bytes=200000

declare -a include_globs=()
declare -a exclude_globs=()

while [[ $# -gt 0 ]]; do
  case "$1" in
    -o|--output)
      output="${2:?missing output file}"
      shift 2
      ;;
    -n|--no-gitignore)
      no_gitignore=1
      shift
      ;;
    -H|--hidden)
      include_hidden=1
      shift
      ;;
    -s|--sort)
      sort_paths=1
      shift
      ;;
    --max-bytes)
      max_bytes="${2:?missing byte count}"
      shift 2
      ;;
    --include)
      include_globs+=("${2:?missing include glob}")
      shift 2
      ;;
    --exclude)
      exclude_globs+=("${2:?missing exclude glob}")
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    -*)
      echo "Unknown option: $1" >&2
      usage >&2
      exit 1
      ;;
    *)
      repo="$1"
      shift
      ;;
  esac
done

if ! command -v rg >/dev/null 2>&1; then
  echo "Error: ripgrep (rg) is required." >&2
  echo "Install it on NixOS with: nix profile install nixpkgs#ripgrep" >&2
  exit 1
fi

if [[ ! -d "$repo" ]]; then
  echo "Error: repo path does not exist or is not a directory: $repo" >&2
  exit 1
fi

cd "$repo"

rg_cmd=(rg --files)

if (( no_gitignore )); then
  rg_cmd+=(--no-ignore)
fi

if (( include_hidden )); then
  rg_cmd+=(--hidden)
fi

if (( sort_paths )); then
  rg_cmd+=(--sort path)
fi

# Reasonable defaults for NixOS config repos.
default_includes=(
  '*.nix'
  '*.lua'
  '*.sh'
  '*.bash'
  '*.zsh'
  '*.fish'
  '*.toml'
  '*.yaml'
  '*.yml'
  '*.json'
  '*.md'
  '*.txt'
  '*.conf'
  '*.ini'
  '*.service'
)

default_excludes=(
  '.git'
  'result'
  'result-*'
  '*.lock'
  '*.png'
  '*.jpg'
  '*.jpeg'
  '*.gif'
  '*.webp'
  '*.svg'
  '*.pdf'
  '*.ttf'
  '*.otf'
  '*.woff'
  '*.woff2'
  '*.mp4'
  '*.mp3'
  '*.zip'
  '*.gz'
  '*.xz'
  '*.zst'
  '*.sqlite'
  '*.db'
  'node_modules/**'
)

if [[ ${#include_globs[@]} -eq 0 ]]; then
  include_globs=("${default_includes[@]}")
fi

exclude_globs+=("${default_excludes[@]}")

for g in "${include_globs[@]}"; do
  rg_cmd+=(-g "$g")
done

for g in "${exclude_globs[@]}"; do
  rg_cmd+=(-g "!$g")
done

emit() {
  printf '# NixOS config export\n\n'
  printf 'Repository: %s\n\n' "$PWD"
  printf 'Format: each file is prefixed by its path and wrapped in a fenced code block.\n\n'

  while IFS= read -r path; do
    [[ -f "$path" ]] || continue

    size=$(wc -c < "$path")
    if [[ "$size" -gt "$max_bytes" ]]; then
      printf '## FILE: %s\n' "$path"
      printf '_Skipped: file too large (%s bytes > %s bytes)_\n\n' "$size" "$max_bytes"
      continue
    fi

    if ! grep -Iq . "$path" 2>/dev/null; then
      printf '## FILE: %s\n' "$path"
      printf '_Skipped: looks binary_\n\n'
      continue
    fi

    ext="${path##*.}"
    if [[ "$path" == "$ext" ]]; then
      ext="text"
    fi

    printf '## FILE: %s\n' "$path"
    printf '```%s\n' "$ext"
    cat -- "$path"
    printf '\n```\n\n'
  done < <("${rg_cmd[@]}")
}

if [[ -n "$output" ]]; then
  emit > "$output"
  echo "Wrote $output"
else
  emit
fi