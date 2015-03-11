FROM debian:jessie

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get -y dist-upgrade && apt-get clean

RUN apt-get install -y --no-install-recommends git vim-nox zsh tmux wget ca-certificates build-essential pkg-config automake locales-all man-db manpages less openssh-client sudo

RUN wget --quiet https://get.docker.com/builds/Linux/x86_64/docker-1.4.1 -O /usr/local/bin/docker && chmod 755 /usr/local/bin/docker

RUN rm /etc/localtime && ln -s /usr/share/zoneinfo/America/New_York /etc/localtime
RUN echo '%sudo ALL=(ALL:ALL) NOPASSWD: ALL' >> /etc/sudoers

RUN adduser --gecos '' --shell /bin/zsh --disabled-password core
RUN usermod -aG sudo core

COPY dotfiles/ /home/core

USER core
WORKDIR /workbench
CMD tmux -u2
