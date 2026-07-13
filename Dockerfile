FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC

RUN apt-get update && \
    apt-get install -y --no-install-recommends tzdata curl sudo ca-certificates && \
    useradd -ms /bin/bash dotfiles && \
    echo 'dotfiles:dotfiles' | chpasswd && \
    usermod -aG sudo dotfiles

WORKDIR /home/dotfiles
USER dotfiles

CMD ["/bin/bash"]
