#!/bin/sh
set -eu

repo_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
codex_dir=${CODEX_HOME:-"$HOME/.codex"}
skills_dir="$codex_dir/skills"

skills="
bvb-update-weights
find-and-send-to-kindle
"

mkdir -p "$skills_dir"

for skill in $skills; do
  source_path="$repo_dir/.codex/skills/$skill"
  target_path="$skills_dir/$skill"

  if [ -L "$target_path" ]; then
    ln -sfn "$source_path" "$target_path"
    printf 'Updated %s\n' "$target_path"
  elif [ -e "$target_path" ]; then
    printf 'Skipped %s (an existing non-symlink path is present)\n' "$target_path" >&2
  else
    ln -s "$source_path" "$target_path"
    printf 'Linked %s\n' "$target_path"
  fi
done
