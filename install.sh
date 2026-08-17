#!/bin/sh
set -eu

repo_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
target_dir=${STOW_TARGET:-"$HOME"}

if ! command -v stow >/dev/null 2>&1; then
  printf 'GNU Stow is required. On macOS, install it with: brew install stow\n' >&2
  exit 127
fi

case ${1:-install} in
  install)
    mode=--restow
    ;;
  delete|uninstall)
    mode=--delete
    ;;
  *)
    printf 'Usage: %s [install|delete]\n' "$0" >&2
    exit 2
    ;;
esac

mkdir -p "$target_dir"
exec stow "$mode" --no-folding --dir="$repo_dir" --target="$target_dir" codex
