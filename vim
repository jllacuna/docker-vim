#!/usr/bin/env sh

docker run -it --rm -v "$PWD":/data jllacuna/vim $@
