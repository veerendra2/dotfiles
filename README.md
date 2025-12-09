# Dotfiles

![GitHub Repo stars](https://img.shields.io/github/stars/veerendra2/dotfiles?style=flat-square)
![GitHub forks](https://img.shields.io/github/forks/veerendra2/dotfiles?style=flat-square)

## Install

<details>

<summary>Prerequire Step For MacOS</summary>

- Install [HomeBrew](https://brew.sh/)

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

- Make sure `$(brew --prefix)/bin` path set in `$PATH`

```bash
brew --prefix
/opt/homebrew
export PATH=$(brew --prefix)/bin:$PATH
```

- Change default `shell` to `bash`

```bash
$ bash -c 'echo $(brew --prefix)/bin/bash | sudo tee -a /etc/shells'
$ chsh -s $(brew --prefix)/bin/bash
```

</details>

```bash
curl https://raw.githubusercontent.com/veerendra2/dotfiles/master/setup.sh | bash
```

## navi

> https://github.com/denisidoro/navi

Press `Ctrl+g` to launch navi as [shell widget](https://github.com/denisidoro/navi/blob/master/docs/widgets/README.md)

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
