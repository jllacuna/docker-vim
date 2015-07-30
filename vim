#!/usr/bin/env sh

docker run -it --rm --name vim -v "$PWD":/data jllacuna/vim $@
