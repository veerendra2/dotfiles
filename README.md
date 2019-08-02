# My dotfiles

My customized `dotfiles` collection
 
## How to install?
_Have install it manually right now...writing an automated python script install it. Check out [one-installer](https://github.com/veerendra2/one-installer)_

## My Other Resources

| Links  | Description |
| ------- | -------------- |
| [my-utils](https://github.com/veerendra2/my-utils)    | scripts, tools, code snippets, tips and tricks  | 
| [my-k8s-applications](https://github.com/veerendra2/my-k8s-applications) | Dockerfiles, K8s deployments, etcs |
| [https://veerendra2.github.io/](https://veerendra2.github.io/)     | My Blog       |


## Content
### `.aliases`

| Aliase  | Actual Command | Description  |
| ------- | -------------- | ------------ |
| `ll`    | `ls -alF`      |         |
| `la`    | `ls -lahF`     |         |
| `l`     | `ls -CF`       |         |
| `lsd`   | `ls -lhF --color \| grep --color=never '^d'` |  List directories only |
| `dl`    | `cd ~/Downloads` |       |
| `dt`    | `cd ~/Desktop`   |         |
| `p`     | `cd ~/PycharmProjects`|     |
| `h`     | `history`      |         |
| `pbcopy` | `xclip -selection clipboard` |  Send data to clipboard       |
| `pbpaste`| `xclip -selection clipboard -o` | Get data from clipboard    |
| `afk`    | `i3lock -c 000000 > /dev/null 2>&1` | Lock   |
| `catn`   | `cat -n` | `cat`s a file with line numbers   |
| `sniff`  | `sudo ngrep -d 'en1' -t '^(GET\|POST) ' 'tcp and port 80'` |  `ngrep`s on port 80 for `GET` or `POST` |
| `pbpaste`| `xclip -selection clipboard -o` |         |
| `pbpaste`| `xclip -selection clipboard -o` |         |


### `.functions`
| Aliase  |  Description   |
| ------- | -------------- |
| `calc`  | Calculator     |
| `tmpd`  | Create `tmp` directory and `cd` |
| `fs`     | File size or total directory size |
| `tmpd`  | Create `tmp` directory and `cd` |
| `fs`     | File size or total directory size |
| `gitio`  | Create a git.io short URL |
| `o`     | Opens directory in UI |
| `openimage` | Opens images with `feh` |
| `flushdns` | Flush Directory Service cache |

### `.dockerfunctions`
| Aliase  |  Description   |
| ------- | -------------- |
| `docker_rm_stopped`  | Removes stopped containers     |
| `docker_stop_all`  | Stop all containers |
| `docker_rm_imgs`  | Removes all Docker images     |
| `docker_rm_stopped_imgs`  | Remove stopped container's Docker images |



## Thanks to :pray:
* [jessfraz](https://github.com/jessfraz) - [https://gist.github.com/joaopizani/2718397](https://gist.github.com/joaopizani/2718397)
* [joaopizani](https://gist.github.com/joaopizani) - [https://github.com/jessfraz/dotfiles](https://github.com/jessfraz/dotfiles)
* [necolas](https://github.com/necolas) - [https://github.com/necolas/dotfiles](https://github.com/necolas/dotfiles)
