FROM fedora

RUN dnf upgrade -y \
 && dnf clean all

# Install things we need

RUN dnf install -y \
                   man-db openssh-clients less findutils sudo tar which xz bzip2 bind-utils \
                   git vim zsh tmux tig \
                   make automake pkgconfig \
                   curl wget file unzip whois \
                   the_silver_searcher \
                   nodejs npm \
                   nmap nmap-ncat \
 && dnf clean all

# Go

RUN wget --quiet https://storage.googleapis.com/golang/go1.5beta2.linux-amd64.tar.gz -O /go.tar.gz \
 && tar -C /usr/local -xzf /go.tar.gz \
 && rm /go.tar.gz

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
