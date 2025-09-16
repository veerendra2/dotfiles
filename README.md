# Dotfiles

## Install

### MacOS

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

### Run

```bash
curl https://raw.githubusercontent.com/veerendra2/dotfiles/master/setup.sh | bash
```
