<h1 align="center">Dotfiles</h1>

<p align="center">
  <img src="assets/banner.png" alt="Dotfiles Banner" width="600px" />
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

This monorepo manages packages and configurations declaratively:

- Linux (Ubuntu):
  - [`apt-bundle`](https://github.com/apt-bundle/apt-bundle)
  - [`homebrew`](https://brew.sh/)
  - [`snap`](https://snapcraft.io/docs/)
- macOS:
  - [`homebrew`](https://brew.sh/)
- Windows:
  - [`winget`](https://learn.microsoft.com/en-gb/windows/package-manager/)

---

## Dotfiles Management

Dotfiles are managed declaratively via [`mise`](https://mise.jdx.dev/)'s
[`dotfiles`](https://mise.jdx.dev/dotfiles.html) feature

```bash
mise dotfiles apply --yes
```

---

## One-Line Installation

```bash
curl -fsSL https://raw.githubusercontent.com/veerendra2/dotfiles/master/bootstrap | bash
```

---

## Custom Cheat Sheets via `navi`

This setup integrates [`navi`](https://github.com/denisidoro/navi), an
interactive, keyboard-driven cheat sheet browser.

- Press `Ctrl+g` to launch navi as
  [shell widget](https://github.com/denisidoro/navi/blob/master/docs/widgets/README.md)
- Cheat sheets are located under `tools/navi/cheats/` and are automatically
  symlinked to `~/.config/navi/cheats` by `mise`.

To manage cheatsheet repositories

```bash
navi repo
Manages cheatsheet repositories

Usage: navi repo <COMMAND>

Commands:
  add     Imports cheatsheets from a repo
  browse  Browses for featured cheatsheet repos
  help    Print this message or the help of the given subcommand(s)

Options:
  -h, --help  Print help
```
