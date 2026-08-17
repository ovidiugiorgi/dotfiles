# My dotfiles

A small collection of personal shell, editor, terminal, and Codex settings.

## GNU Stow

Newly managed areas use Stow packages; the older shell and editor files remain
in their legacy layout for now. The first package is `codex/`, which maps into
your home directory, so `codex/.codex/skills/...` becomes
`~/.codex/skills/...`.

The tracked Codex skills are:

- `bvb-update-weights`
- `find-and-send-to-kindle`

Install GNU Stow on macOS, then link the package:

```sh
brew install stow
./install.sh
```

Remove the managed links with `./install.sh delete`.

The wrapper uses Stow's `--no-folding` mode so `~/.codex` remains a real local
directory for Codex runtime state. Stow also stops on conflicts rather than
overwriting existing unmanaged files. Move or compare an existing skill before
the first install; avoid `--adopt` unless you have reviewed exactly what it will
change in the repository.

The package-local `.stow-local-ignore` blocks environment files, credentials,
secrets, local overrides, downloads, output folders, work folders, and Python
caches even if one of those files exists locally but is not tracked by Git.

Private spreadsheet URLs, email addresses, credentials, downloaded books, and
runtime output do not belong in this repository. Supply those values when a
skill runs.
