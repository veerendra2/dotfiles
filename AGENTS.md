# AGENTS.md — Dotfiles Repository Guide

This file provides context for agentic coding assistants (Codex, Claude, Copilot, etc.)
operating in this repository.

---

## Repository Overview

Personal dotfiles managed with **GNU Stow**. The repo must live at `~/projects/dotfiles`
(this path is hardcoded in `setup.sh` and `git/.gitconfig`). Stow creates symlinks from
each package directory into the appropriate target directory.

### Stow Package Layout

| Package dir | Stow target | Notes                                                             |
| ----------- | ----------- | ----------------------------------------------------------------- |
| `bash/`     | `~`         | `.aliases`, `.bash_profile`, `.bashrc`, `.exports`, `.functions`  |
| `curl/`     | `~`         | `.curlrc`                                                         |
| `git/`      | `~`         | `.gitconfig`, `.extra-gitconfig`                                  |
| `screen/`   | `~`         | `.screenrc`                                                       |
| `.config/`  | `~/.config` | `direnv/`, `ghostty/`, `navi/`, `starship/` — uses `--no-folding` |
| `.vim/`     | `~/.vim`    | `colors/`, `vimrc` — uses `--no-folding`                          |
| `.ssh/`     | `~/.ssh`    | `config` — uses `--no-folding`                                    |

The `--no-folding` flag is critical for `.config/`, `.vim/`, and `.ssh/`: it symlinks
individual files rather than whole directories, so non-tracked files can coexist.

---

## Setup / Install Commands

There is no Makefile, package.json, or task runner. The single entry point is `setup.sh`.

```bash
# Install dotfiles (default action)
bash setup.sh
bash setup.sh -i
bash setup.sh --install

# Re-stow — refresh symlinks after adding/moving files
bash setup.sh -r
bash setup.sh --re-stow

# Uninstall — remove all symlinks
bash setup.sh -d
bash setup.sh --delete

# Help
bash setup.sh -h
```

**There are no test commands.** This is a dotfiles repository; correctness is validated
manually by sourcing the relevant files or by running `setup.sh` in a fresh environment.

To manually validate a specific shell file after editing:

```bash
# Syntax-check a bash file without executing it
bash -n bash/.bashrc
bash -n bash/.aliases
bash -n bash/.functions
bash -n setup.sh

# If shellcheck is available (recommended)
shellcheck setup.sh
shellcheck bash/.functions
shellcheck bash/.aliases
```

---

## Languages and File Formats

| Language / Format | Locations                                                      |
| ----------------- | -------------------------------------------------------------- |
| Bash              | `setup.sh`, `bash/.*` (all shell dotfiles)                     |
| Vim Script        | `.vim/vimrc`, `.vim/colors/monokai.vim`                        |
| TOML              | `.config/starship/starship.toml`, `.config/direnv/direnv.toml` |
| YAML              | `.config/navi/config.yaml`                                     |
| Navi cheat format | `.config/navi/cheats/*.cheat` (39 files)                       |
| Ghostty config    | `.config/ghostty/config` (key=value)                           |
| Git config INI    | `git/.gitconfig`, `git/.extra-gitconfig`                       |
| SSH config        | `.ssh/config`                                                  |

---

## Code Style Guidelines

### Shell / Bash

- **Shebang:** Always `#!/usr/bin/env bash` — never `/bin/bash` or `/bin/sh`.
- **Strict mode:** Use `set -e` in executable scripts (e.g., `setup.sh`). Sourced files
  (`.bashrc`, `.aliases`, `.functions`) do not use `set -e`.
- **Indentation:** Tabs inside `case` blocks (as in `.bashrc`); 4 spaces in function
  bodies in `.functions`. Be consistent within the file you are editing.
- **Variable quoting:** Always double-quote variables: `"$var"`, `"${VAR}"`. Unquoted
  variables are only acceptable in controlled numeric/arithmetic contexts.
- **Variable naming:**
  - Environment/exported variables: `UPPER_SNAKE_CASE` (e.g., `HISTSIZE`, `GOPATH`,
    `PYENV_ROOT`, `STARSHIP_CONFIG`, `NAVI_CONFIG`)
  - Local function variables: `lower_snake_case` with `local` keyword
  - Loop variables: short and descriptive (`file`, `pkg`, `dir`)
- **Function naming:** `snake_case` (e.g., `docker_rm_stopped`, `ssl_validity`,
  `curltime`, `set_win_title`).
- **Local variables in functions:** Always declare with `local`:
  ```bash
  my_func() {
      local result=""
      local dir
      ...
  }
  ```
- **Conditionals:** Use `[[ ... ]]` (double brackets) for all tests in bash scripts.
  Use `[ ... ]` only when POSIX portability is explicitly required.
- **Command substitution:** Use `$(...)` — never backtick `` `...` ``.
- **Error suppression:** Redirect stderr explicitly (`2>/dev/null`) when intentional;
  do not use bare `|| true` except to silence expected failures.
- **Comments:** Add `#` comments explaining intent (not mechanics) for non-obvious blocks.
  Inline comments are fine for short clarifications.

### Alias Style (`.aliases`)

- Keep aliases short and memorable (e.g., `k`, `kx`, `kn`, `np`, `npc`).
- Group aliases by tool/category with a `# Category` comment header.
- Prefer single-quoted values unless expansion is needed.

### Navi Cheat Files (`.config/navi/cheats/*.cheat`)

- Filename: `<tool>.cheat`, all lowercase, e.g., `kubectl.cheat`, `git.cheat`.
- Structure:

  ```
  % category, tag1, tag2

  # Short description of the command
  $ variable: echo "value1" --- value2 value3
  command --flag <variable>
  ```

- Use `%` for category/tag headers.
- Use `#` for human-readable command descriptions.
- Use `;` for sub-comments or notes within an entry.

### Vim Script (`.vim/vimrc`)

- 2-space indentation (`set tabstop=2 shiftwidth=2 expandtab`).
- 80-character soft line limit (ColorColumn set at col 81+).
- Group settings with comment headers (e.g., `" --- UI Settings ---`).

### TOML / YAML

- 2-space indentation for YAML.
- Follow the conventions already established in each file.

---

## Naming Conventions

| Artifact          | Convention                                     | Example                         |
| ----------------- | ---------------------------------------------- | ------------------------------- |
| Exported env vars | `UPPER_SNAKE_CASE`                             | `GOPATH`, `PYENV_ROOT`          |
| Bash functions    | `snake_case`                                   | `docker_rm_stopped`, `curltime` |
| Shell aliases     | Short abbreviations or `snake_case`            | `k`, `kx`, `self_cert`          |
| Git aliases       | Lowercase, concise                             | `lg`, `graph`, `contributors`   |
| Stow package dirs | Named after the tool or purpose                | `bash`, `curl`, `git`           |
| Navi cheat files  | `<tool>.cheat`, all lowercase                  | `kubectl.cheat`, `helm.cheat`   |
| Branch names      | Lowercase with hyphens, issue-number prefix OK | `3-use-stow`, `add-cheats`      |
| Commit messages   | Imperative, sentence-style, no trailing period | `Add strimzi kafka cheatsheet`  |

---

## Gitignored Files (Machine-Local Overrides)

Two files are intentionally gitignored and serve as escape hatches for machine-specific
settings. They are created empty by `setup.sh`:

- **`bash/.extra`** — sourced last by `.bashrc`; put API keys, machine-local `PATH`
  additions, and private aliases here.
- **`git/.extra-gitconfig`** — included conditionally by `.gitconfig` via
  `[includeIf "gitdir:~/projects/office/"]`; put office email/credentials here.

**Never commit secrets or machine-specific credentials to the repo.**

---

## Adding New Dotfiles

1. Place the file in the appropriate stow package directory (or create a new one).
2. For new packages targeting `~`, add the package name to the `dotfiles` array in
   `setup.sh`.
3. For new packages targeting a non-home directory (e.g., `~/.config/`), add an explicit
   `stow` call for `-i`, `-r`, and `-d` actions in `setup.sh`.
4. Run `bash setup.sh -r` to refresh symlinks.
5. Add a `--no-folding` flag if the target dir may contain non-tracked files.

## Adding New Navi Cheat Files

1. Create `.config/navi/cheats/<tool>.cheat` (lowercase).
2. Follow the `% category` / `# description` / `command` format.
3. Test with `navi --print` interactively or `navi --query "<keyword>"`.

---

## No CI/CD

There are no GitHub Actions workflows, no linting pipelines, and no automated tests.
All validation is done manually. If you add a script, run `bash -n <file>` and ideally
`shellcheck <file>` before committing.
