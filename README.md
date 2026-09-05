<h1 align="center">Dotfiles</h1>

<p align="center">
  <img src="assets/image.png" alt="Dotfiles Banner" width="250px" />
</p>

<p align="center">
  <!-- GitHub Badges -->
  <img src="https://img.shields.io/github/stars/veerendra2/dotfiles?style=flat-square&color=F1C40F" alt="GitHub Repo stars" />
  <img src="https://img.shields.io/github/forks/veerendra2/dotfiles?style=flat-square&color=3498DB" alt="GitHub forks" />

  <!-- Operating System Badges -->
  <img src="https://img.shields.io/badge/OS-Ubuntu-E95420?style=flat-square&logo=ubuntu&logoColor=white" alt="Ubuntu" />
  <img src="https://img.shields.io/badge/OS-macOS-000000?style=flat-square&logo=apple&logoColor=white" alt="macOS" />
  <img src="https://img.shields.io/badge/OS-Windows-0078D4?style=flat-square&logo=windows&logoColor=white" alt="Windows" />

  <!-- Package Manager Badges -->
  <img src="https://img.shields.io/badge/Install-Homebrew-F1C40F?style=flat-square&logo=homebrew&logoColor=black" alt="Homebrew" />
  <img src="https://img.shields.io/badge/Install-APT-121011?style=flat-square&logo=debian&logoColor=red" alt="APT" />
  <img src="https://img.shields.io/badge/Install-Snap-820D3F?style=flat-square&logo=snapcraft&logoColor=white" alt="Snap" />
  <img src="https://img.shields.io/badge/Install-Winget-0078D4?style=flat-square&logo=windows&logoColor=white" alt="Winget" />
</p>

---

## Package Management

Cross-platform package setup

- **Linux (Ubuntu)**:
  - [`apt-bundle`](https://github.com/apt-bundle/apt-bundle)
  - [`homebrew`](https://brew.sh/)
  - [`snap`](https://snapcraft.io/docs/)
- **macOS**:
  - [`homebrew`](https://brew.sh/)
- **Windows**:
  - [`winget`](https://learn.microsoft.com/en-gb/windows/package-manager/)

---

## Dotfiles Management

Apply dotfiles via [`symlinkr`](https://github.com/veerendra2/symlinkr):

```bash
# Install
brew install veerendra2/tap/symlinkr

# Apply
symlinkr --config symlinkr.yaml -f

# Uninstall (remove) symlinks
symlinkr --config symlinkr.yaml -r
```

---

## Runtimes and Python Tools

macOS uses Homebrew for Python 3.14, Node.js (including npm), and Python CLI
tools. Ubuntu uses APT for Python 3, Node.js, npm, and available Python tools
and libraries, with Homebrew for the remaining CLIs. Ubuntu package availability
was checked against 24.04; Python follows the distribution version.

Both Brewfiles use `uv` entries for `claude-chat-to-md` and `toolong`, which have
no Homebrew formula or Ubuntu 24.04 package. Homebrew Bundle installs these into
isolated tool environments; `~/.local/bin` is already on the shell PATH.

For Python libraries on macOS, use a project virtual environment instead of
installing into Homebrew's externally managed Python:

```bash
python3 -m venv .venv
.venv/bin/python -m pip install requests beautifulsoup4 jmespath loguru jc rich
```

Existing runtime-manager installations and environments are not uninstalled by
bootstrap. Restart your shell after applying the updated dotfiles to drop old
shell activation.

---

## Pi Local Models

Ollama models are registered by `tools/pi/extensions/ollama.ts`, symlinked to
`~/.pi/agent/extensions/ollama.ts`. Pi loads this extension automatically; use
`/reload` in an existing session after applying the symlinks.

The extension discovers installed models from `http://localhost:11434/api/tags`
at startup and on `/reload`, and uses `http://localhost:11434/v1` for inference.
After pulling or deleting models in Ollama, run `/reload`, then select a model
through `/model` or `pi --model ollama/qwen3.8:latest`.
Discovery has a five-second timeout; if Ollama is unavailable, Pi still starts
with a warning. Registration does not download models or change Pi's default model.

Keep other provider settings in `~/.pi/agent/models.json` and credentials outside
this repository. If you previously copied the old Pi config there, remove only
its `providers.ollama` entry to avoid overriding the extension's model list.

The extension uses text-only mode with reasoning controls disabled and a
32,768-token context budget (4,096 output tokens). Adjust these values to match
your Ollama server's configured context and model capabilities.

---

## Installation

### macOS & Linux

```bash
curl -fsSL https://raw.githubusercontent.com/veerendra2/dotfiles/master/bootstrap | bash
```

### Windows

```powershell
irm https://raw.githubusercontent.com/veerendra2/dotfiles/refactor-to-make-monorepo/windows/install.ps1 | iex
```

---

## Custom Cheat Sheets via `navi`

Terminal cheatsheet integration:

- Press `Ctrl+g` to launch navi as
  [shell widget](https://github.com/denisidoro/navi/blob/master/docs/widgets/README.md)
- Custom sheets are at `tools/navi/cheats/` and are automatically symlinked to
  `~/.config/navi/cheats`.

Manage cheatsheet repositories:

```bash
navi repo --help
Manages cheatsheet repositories

Usage: navi repo <COMMAND>

Commands:
  add     Imports cheatsheets from a repo
  browse  Browses for featured cheatsheet repos
  help    Print this message or the help of the given subcommand(s)

Options:
  -h, --help  Print help
```

## Tips for Machine-Specific Dotfiles

> These files are not tracked in git — use them for machine-specific overrides
> that shouldn't be shared or committed.

### Env

`shell/common/.extra`

```sh
# Put local Homebrew path(`~/.local/Homebrew`) first
export LOCAL_HOMEBREW=1

# Override Claude Code settings
export ANTHROPIC_BASE_URL="https://your-gateway/v1"
export ANTHROPIC_API_KEY="YOUR_API_KEY"
export ANTHROPIC_MODEL="claude-sonnet-4.6"
export CLAUDE_CODE_ENABLE_GATEWAY_MODEL_DISCOVERY=1

# Let Node.js (npm/Pi) trust the system CA bundle; restart Pi after setting this.
export NODE_EXTRA_CA_CERTS=/etc/ssl/cert.pem
```

### Ghostty Config

> - See
>   [Splitting into Multiple Files](https://ghostty.org/docs/config#splitting-into-multiple-files)
> - [Config Generator](https://ghostty.zerebos.com/)

`tools/ghostty/local`

```sh
# Launch a custom command or shell on Ghostty start
# Useful here for forcing bash to launch
command = ~/.local/Homebrew/bin/bash -l
```

### Git Config

`tools/git/.extra-gitconfig`

```ini
# e.g. use a custom email for commits on this machine
[user]
  email = your-custom-email@example.com
```

## Testing Locally

```bash
docker build --no-cache --tag dotfiles:latest .
...

docker run -it --rm -v ./:/home/dotfiles/dotfiles dotfiles:latest
dotfiles@135ec4adbe1c:~$ ./dotfiles/bootstrap
[sudo] password for dotfiles:
...
```
