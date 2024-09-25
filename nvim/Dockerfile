#
# Stage: base
#
FROM jllacuna/nvim AS cache
FROM golang:alpine AS golang
FROM alpine:3.20 AS base

ARG NVIM_CONFIG_PATH=/root/.config
ARG GO_DIR=/usr/local/go
ARG LSP_SERVERS=/usr/local/lib/lsp_servers
ARG PARSER_DIR=/usr/local/lib/treesitter_parsers
ARG MASON_DIR=/usr/local/lib/mason
ARG NEOVIM_VERSION=0.10.1

# Install nodejs and npm
RUN apk add --no-cache \
  nodejs \
  npm

# Install ruby
RUN apk add --no-cache \
  ruby \
  ruby-dev

# Install go
COPY --from=golang $GO_DIR $GO_DIR
ENV PATH=$PATH:$GO_DIR/bin

# Install rust and cargo
RUN apk add --no-cache \
  rust \
  cargo

# Install build tools
RUN apk add --no-cache \
  build-base \
  curl \
  gzip \
  bash

# Install telescope dependencies
RUN apk add --no-cache \
  ripgrep \
  fd \
  git

# Install tree-sitter
RUN apk add --no-cache --virtual .deps gcompat \
  && npm install -g tree-sitter-cli \
  && apk del .deps

# Install glow from alpine/edge/testing
# CLI Markdown reader
# https://github.com/charmbracelet/glow
RUN apk add --no-cache --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing \
  glow

# Install neovim from source
RUN apk add --no-cache --virtual .deps cmake coreutils unzip gettext-tiny-dev \
  && curl --create-dirs -Lo /root/.local/share/neovim.tar.gz https://github.com/neovim/neovim/archive/refs/tags/v${NEOVIM_VERSION}.tar.gz \
  && cd /root/.local/share && tar xvzf neovim.tar.gz && rm neovim.tar.gz && mv neovim-${NEOVIM_VERSION} neovim \
  && cd /root/.local/share/neovim && make CMAKE_BUILD_TYPE=RelWithDebInfo && make install \
  && apk del .deps

# Set GOPATH to our volumed workspace
# Allows gopls to reference our imported modules
ENV GOPATH=/workspace/go

WORKDIR /data

ENTRYPOINT [ "nvim" ]

#
# Stage: cached
#
FROM base AS cached

# Copy treesitter parsers and mason installs from existing image to avoid their build time
COPY --from=cache $PARSER_DIR $PARSER_DIR
COPY --from=cache $MASON_DIR $MASON_DIR

# Copy neovim config to root home
COPY config $NVIM_CONFIG_PATH

# Install plugins with lazy.nvim
RUN nvim --headless "+Lazy! sync" +qa

#
# Stage: not_cached
#
FROM base AS not_cached

# Copy neovim config to root home
COPY config $NVIM_CONFIG_PATH

# Install plugins with lazy.nvim
RUN nvim --headless "+Lazy! sync" +qa

# Install lsp servers with mason
# Can list multiple servers with mason
# This format makes it easy to comment out a server while still only generating one Docker layer
# WARNING: Can run up to 10 +/-c commands
RUN nvim --headless \
  +"MasonInstall bash-language-server" \
  +"MasonInstall css-lsp html-lsp json-lsp" \
  +"MasonInstall dockerfile-language-server docker-compose-language-service" \
  +"MasonInstall gopls" \
  +"MasonInstall lua-language-server" \
  +"MasonInstall marksman" \
  +"MasonInstall svelte-language-server" \
  +"MasonInstall vtsls" \
  +"MasonInstall taplo yaml-language-server" \
  +qa
