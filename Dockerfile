FROM debian:stretch

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
 && apt-get -y dist-upgrade \
 && apt-get clean

# Install things we need

RUN apt-get update \
 && apt-get install -y \
        ca-certificates \
        man-db \
        less \
        findutils \
        sudo \
        tar \
        bzip2 \
        iproute \
        git \
        mercurial \
        vim \
        zsh \
        tig \
        make \
        automake \
        gcc \
        curl \
        wget \
        file \
        unzip \
        whois \
        nodejs \
        nmap \
        traceroute \
        bind9-host \
        silversearcher-ag \
        openssh-client \
        procps \
        software-properties-common \
        gnupg \
        apt-transport-https \
        libevent-dev \
        libncurses5-dev \
        locales \
        tree \
 && apt-get clean

# Docker

RUN curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian stretch stable"

RUN apt-get update && apt-get install -y docker-ce && apt-get clean
RUN wget --quiet https://github.com/docker/compose/releases/download/1.15.0/docker-compose-Linux-x86_64 -O /usr/local/bin/docker-compose \
 && chmod 755 /usr/local/bin/docker-compose

# Fix nodejs
RUN ln -s /usr/bin/nodejs /usr/local/bin/node

# Go

RUN wget --quiet https://storage.googleapis.com/golang/go1.8.1.linux-amd64.tar.gz -O /go.tar.gz \
 && tar -C /usr/local -xzf /go.tar.gz \
 && rm /go.tar.gz

# tmux

RUN wget --quiet https://github.com/tmux/tmux/releases/download/2.1/tmux-2.1.tar.gz -O /tmux.tar.gz \
 && tar xzf tmux.tar.gz \
 && cd /tmux-2.1 \
 && ./configure \
 && make \
 && make install \
 && cd / \
 && rm -rf /tmux-2.1

# json
# RUN npm install -g json

# Set things up

RUN echo 'en_US.UTF-8 UTF-8' > /etc/locale.gen \
 && locale-gen
RUN rm /etc/localtime \
 && ln -s /usr/share/zoneinfo/America/New_York /etc/localtime
RUN echo '%sudo ALL=(ALL:ALL) NOPASSWD: ALL' >> /etc/sudoers

# User

RUN adduser --gecos '' --shell /bin/zsh --disabled-password core
RUN usermod -aG sudo core

COPY dotfiles/ /home/core
RUN mkdir -p /home/core/.ssh
COPY keys/* /home/core/.ssh/

# vim

RUN mkdir -p /home/core/.vim/bundle
RUN git -C /home/core/.vim/bundle clone https://github.com/sunaku/vim-unbundle.git
RUN git -C /home/core/.vim/bundle clone https://github.com/tpope/vim-commentary.git
RUN git -C /home/core/.vim/bundle clone https://github.com/msanders/snipmate.vim.git
RUN git -C /home/core/.vim/bundle clone https://github.com/fatih/vim-go.git
RUN git -C /home/core/.vim/bundle clone https://github.com/scrooloose/syntastic.git

RUN chown core:core -R /home/core

# Running

ENV DEBIAN_FRONTEND=
USER core
WORKDIR /workbench
CMD ["tmux", "-u2"]
