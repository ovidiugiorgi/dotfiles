# My dotfiles

A small collection of personal shell, editor, terminal, and Codex settings.

## GNU Stow

Managed areas use Stow packages that map into your home directory:

- `zsh/.zshrc` becomes `~/.zshrc`.
- `herdr/.config/herdr/config.toml` becomes `~/.config/herdr/config.toml`.
- `ghostty/.config/ghostty/config` becomes `~/.config/ghostty/config`.
- `codex/.codex/skills/...` becomes `~/.codex/skills/...`.

Herdr sessions, snapshots, logs, locks, sockets, and config backups stay local.
Only the active Herdr and Ghostty configuration files are managed.

The older editor and terminal files remain in their legacy layout.

The tracked Codex skills are:

- `bvb-update-weights`
- `find-and-send-to-kindle`

Install GNU Stow on macOS, then link the packages:

```sh
brew install stow
./install.sh
```

For an existing regular `~/.zshrc`, first copy its contents to `zsh/.zshrc`
and move the original to a backup outside the repo. Then run `./install.sh`.
Once linked, edits to `~/.zshrc` edit the tracked file directly; commit and
push those changes to sync them to GitHub.

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
