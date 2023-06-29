# My dotfiles

My customized `dotfiles` collection (With Kubernetes prompt :sunglasses:)

* Check out [wiki pages](https://github.com/veerendra2/dotfiles/wiki) to know all shortcuts

![image](https://user-images.githubusercontent.com/8393701/184549504-b46ba73c-4a7b-42a9-8f9b-9c3010a8cac7.png)
## Install
* Install dependecy packages
  ```bash
  if [ $(uname -s) = "Linux" ] \
  $ apt-get update
  $ apt-get install \
      curl feh xclip \
      ngrep pv openssl \
      python3-pip -y
  $ curl -qo /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 > /dev/null 2>&1
  $ chmod +x /usr/local/bin/yq
  fi

  if [ $(uname -s) = "Darwin" ] \
    $ brew install yq ngrep openssl pv curl
    $ curl https://bootstrap.pypa.io/get-pip.py | python3
  fi
  ```
* Install dotfiles
  ```bash
  $ curl https://raw.githubusercontent.com/veerendra2/dotfiles/master/install.sh | bash
  $ bash


