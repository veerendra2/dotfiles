# Bash

## Configure `bash`(Homebrew) in iTerm for MacOS

> More info https://stackoverflow.com/questions/23059662

This configuration is need when latest bash installed from homebrew package manager.

- Change default `shell` to `bash`
  ```bash
  $ bash -c 'echo $(brew --prefix)/bin/bash | sudo tee -a /etc/shells'
  $ chsh -s $(brew --prefix)/bin/bash
  ```
- Update `bash` location `command` in iTerm profiles like below.

  > **NOTE: You can the get `bash` binary location by running `echo $(brew --prefix)/bin/bash`. For apple silicon it should be `/opt/homebrew/bin/bash` and for intel `/usr/local/bin/bash`**

  <img src="https://user-images.githubusercontent.com/8393701/249885411-c841014c-ab37-41c4-8a57-7b95fda573f0.png" width="500"/>
