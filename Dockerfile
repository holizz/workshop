FROM debian:jessie

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
 && apt-get -y dist-upgrade \
 && apt-get clean

# Install things we need

RUN apt-get install -y --no-install-recommends git vim-nox zsh tmux wget ca-certificates build-essential pkg-config automake locales-all man-db manpages less openssh-client sudo tig file curl nodejs npm silversearcher-ag python python3 unzip libevent-dev libncurses5-dev netcat-openbsd whois

# Fix node

RUN ln -s /usr/bin/nodejs /usr/bin/node

# Go

RUN wget --quiet https://storage.googleapis.com/golang/go1.5beta1.linux-amd64.tar.gz -O /go.tar.gz \
 && tar -C /usr/local -xzf /go.tar.gz \
 && rm /go.tar.gz

# Set things up

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

USER core
WORKDIR /workbench
CMD ["tmux", "-u2"]
