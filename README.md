# workshop

I used to use a dotfiles repository to store the dotfiles for my development environment. Now my development environment is a docker container.

## Inspiration

https://www.youtube.com/watch?v=M9hBsRUeRdg

## Requirements

1. A directory called /workbench where you have some things you want to hack on
2. Docker running on the local machine
3. /var/run/docker.sock should be chmodded 777 (if you want to work with docker without constantly having to use sudo)

## Usage

    docker build -t workshop .
    docker run -ti --rm --name workshop --hostname workshop -v /workbench:/workbench -v /var/run/docker.sock:/var/run/docker.sock workshop

## Licence

MIT
