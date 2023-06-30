# dotfiles

Customized `dotfiles` collection (With Kubernetes prompt :sunglasses:).

:diamond_shape_with_a_dot_inside: _Refer :books:[wiki pages](https://github.com/veerendra2/dotfiles/wiki):books: to know all shortcuts._

<img src="https://user-images.githubusercontent.com/8393701/184549504-b46ba73c-4a7b-42a9-8f9b-9c3010a8cac7.png" width="700"/>

## Install
* Install dependecy packages
  ```bash
  # Linux
  $ apt-get update
  $ apt-get install \
      curl feh xclip \
      ngrep pv openssl -y
  $ curl -qo /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 > /dev/null 2>&1
  $ chmod +x /usr/local/bin/yq


  # MacOS
  $ brew install yq ngrep openssl pv curl
  ```

* Install dotfiles
  ```bash
  $ curl https://raw.githubusercontent.com/veerendra2/dotfiles/master/install.sh | bash
  $ bash
  ```

## Configure `bash` in iTerm for MacOS
> More info -> https://stackoverflow.com/questions/23059662
* Run following commands to change `shell`
```bash
$ sudo bash -c 'echo /usr/local/bin/bash >> /etc/shells'
$ chsh -s /usr/local/bin/bash
```
* Update "command" `/usr/local/bin/bash -l` in iTerm profiles like below

<img src="https://user-images.githubusercontent.com/8393701/249885411-c841014c-ab37-41c4-8a57-7b95fda573f0.png" width="500"/>
