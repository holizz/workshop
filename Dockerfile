FROM fedora:25

RUN dnf upgrade -y \
 && dnf clean all

# Install things we need

RUN dnf install -y \
                   man-db openssh-clients less findutils sudo tar which xz bzip2 bind-utils iputils iproute procps-ng man-pages \
                   git mercurial vim zsh tig \
                   make automake pkgconfig gcc \
                   libevent-devel ncurses-devel \
                   curl wget file unzip whois \
                   the_silver_searcher \
                   nodejs npm \
                   nmap nmap-ncat traceroute \
 && dnf clean all

# Docker

COPY docker.repo /etc/yum.repos.d/
RUN dnf install -y docker-engine-1.11.1

# Go

RUN wget --quiet https://storage.googleapis.com/golang/go1.7.linux-amd64.tar.gz -O /go.tar.gz \
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
RUN npm install -g json

# Set things up

RUN rm /etc/localtime \
 && ln -s /usr/share/zoneinfo/America/New_York /etc/localtime
RUN echo 'core ALL=(ALL:ALL) NOPASSWD: ALL' >> /etc/sudoers

# User

RUN useradd --password '' --shell /usr/bin/zsh core

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

USER core
WORKDIR /workbench
CMD ["tmux", "-u2"]
