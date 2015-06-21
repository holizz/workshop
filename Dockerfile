FROM debian:jessie

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
 && apt-get -y dist-upgrade \
 && apt-get clean

# Install things we need

RUN apt-get install -y --no-install-recommends git vim-nox zsh tmux wget ca-certificates build-essential pkg-config automake locales-all man-db manpages less openssh-client sudo tig file curl nodejs npm silversearcher-ag python python3 unzip libevent-dev libncurses5-dev

# Fix node
RUN ln -s /usr/bin/nodejs /usr/bin/node

# Go

# Get a 1.4 binary
RUN mkdir -p /src
RUN wget --quiet https://storage.googleapis.com/golang/go1.4.2.linux-amd64.tar.gz -O /src/go.tar.gz \
 && tar -C /src -xzf /src/go.tar.gz \
 && rm /src/go.tar.gz
# Build master from source
RUN git clone --branch master https://go.googlesource.com/go /src/golatest \
 && mv /src/golatest /usr/local/go \
 && cd /usr/local/go/src \
 && GOROOT_BOOTSTRAP=/src/go ./make.bash \
 && rm -rf /usr/local/go/.git
RUN rm -rf /src
ENV PATH=$PATH:/usr/local/go/bin

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
