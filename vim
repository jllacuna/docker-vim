#!/usr/bin/env sh

docker run -it --rm --cpus="2" -v "$PWD":/data -v "$HOME/workspace":/workspace jllacuna/vim $@
