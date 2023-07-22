# dotfiles
> With Kubernetes prompt :sunglasses:

<img src="https://user-images.githubusercontent.com/8393701/184549504-b46ba73c-4a7b-42a9-8f9b-9c3010a8cac7.png" width="700"/>

## Install
* Install dependency packages
  ```bash
  # Linux
  $ apt-get update
  $ apt-get install \
      curl feh xclip \
      ngrep pv openssl -y
  $ curl -qo /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 > /dev/null 2>&1
  $ chmod +x /usr/local/bin/yq

  # MacOS
  # install homebrew
  $ brew install yq ngrep openssl pv curl
  ```

* Install dotfiles
  ```bash
  $ curl https://raw.githubusercontent.com/veerendra2/dotfiles/master/install | bash
  $ bash
  ```

## Configure `bash`(Homebrew) in iTerm for MacOS
> More info https://stackoverflow.com/questions/23059662

This configuration is need when latest bash installed from homebrew package manager.

* Change default `shell` to `bash`
  ```bash
  $ bash -c 'echo $(brew --prefix)/bin/bash | sudo tee -a /etc/shells'
  $ chsh -s $(brew --prefix)/bin/bash
  ```
* Update `bash` location `command` in iTerm profiles like below.
  > **NOTE: You can the get `bash` binary location by running `echo $(brew --prefix)/bin/bash`. For apple silicon it should be `/opt/homebrew/bin/bash` and for intel `/usr/local/bin/bash`**

  <img src="https://user-images.githubusercontent.com/8393701/249885411-c841014c-ab37-41c4-8a57-7b95fda573f0.png" width="500"/>
