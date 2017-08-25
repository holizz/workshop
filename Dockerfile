FROM debian:stretch

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
 && apt-get -y dist-upgrade \
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
        netcat-openbsd \
        tmux \
 && apt-get clean

# Fix nodejs
RUN ln -s /usr/bin/nodejs /usr/local/bin/node

# Go
RUN wget --quiet https://storage.googleapis.com/golang/`curl -s https://golang.org/VERSION?m=text`.linux-amd64.tar.gz -O /go.tar.gz \
 && tar -C /usr/local -xzf /go.tar.gz \
 && rm /go.tar.gz

# Docker
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian stretch stable"
RUN apt-get update && apt-get install -y docker-ce && apt-get clean
RUN wget --quiet https://github.com/docker/compose/releases/download/1.15.0/docker-compose-Linux-x86_64 -O /usr/local/bin/docker-compose \
 && chmod 755 /usr/local/bin/docker-compose

# l10n
RUN echo 'en_US.UTF-8 UTF-8' > /etc/locale.gen \
 && locale-gen
RUN rm /etc/localtime \
 && ln -s /usr/share/zoneinfo/America/New_York /etc/localtime

# sudo
RUN echo '%sudo ALL=(ALL:ALL) NOPASSWD: ALL' >> /etc/sudoers

# User
RUN adduser --gecos '' --shell /bin/zsh --disabled-password core
RUN usermod -aG sudo core

# vim
RUN mkdir -p /home/core/.vim/bundle
RUN git -C /home/core/.vim/bundle clone https://github.com/sunaku/vim-unbundle.git
RUN git -C /home/core/.vim/bundle clone https://github.com/tpope/vim-commentary.git
RUN git -C /home/core/.vim/bundle clone https://github.com/msanders/snipmate.vim.git
RUN git -C /home/core/.vim/bundle clone https://github.com/fatih/vim-go.git
RUN git -C /home/core/.vim/bundle clone https://github.com/scrooloose/syntastic.git
RUN /usr/local/go/bin/go get github.com/TrustRevoked/iferr

# Dotfiles
COPY dotfiles/ /home/core
RUN mkdir -p /home/core/.ssh
COPY keys/* /home/core/.ssh/
RUN chown core:core -R /home/core

# Runtime
ENV DEBIAN_FRONTEND=
USER core
WORKDIR /workbench
CMD ["tmux", "-u2"]
