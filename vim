#!/usr/bin/env sh

docker run -it --rm -v "$PWD":/data -v "$HOME/workspace":/workspace jllacuna/vim $@
