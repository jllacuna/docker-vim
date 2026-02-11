# Stage: treesitter
FROM alpine:3.23 AS treesitter

RUN apk add --no-cache curl clang-dev

# Install rust and cargo
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH=$PATH:/root/.cargo/bin

# Install tree-sitter
RUN RUSTFLAGS="-C target-feature=-crt-static" cargo install tree-sitter-cli --locked --color=never

# Stage: lua-language-server
FROM alpine:3.23 AS lua-language-server

# Install lua-language-server from source
# Mason install causes errors
RUN apk add --no-cache bash git build-base ninja linux-headers
RUN git clone https://github.com/LuaLS/lua-language-server \
  && cd lua-language-server \
  && chmod +x ./make.sh \
  && ./make.sh

# Stage: neovim
FROM alpine:3.23 AS neovim

ARG NEOVIM_VERSION=0.11.6

# Install neovim from source
RUN apk add --no-cache curl build-base cmake coreutils unzip gettext-tiny-dev 
RUN curl -Lo neovim.tar.gz https://github.com/neovim/neovim/archive/refs/tags/v${NEOVIM_VERSION}.tar.gz \
  && tar xvzf neovim.tar.gz && rm neovim.tar.gz && cd neovim-${NEOVIM_VERSION} \
  && make CMAKE_BUILD_TYPE=RelWithDebInfo \
  && make DESTDIR=/tmp/nvim_dist install

#
# Stage: base
#
FROM jllacuna/nvim AS cache
FROM golang:1.25.7-alpine3.23 AS golang
FROM node:24.13.0-alpine3.23 AS base

ARG NVIM_CONFIG_PATH=/root/.config
ARG GO_DIR=/usr/local/go
ARG PARSER_DIR=/usr/local/lib/treesitter_parsers
ARG MASON_DIR=/usr/local/lib/mason

# Install ruby
# RUN apk add --no-cache \
#   ruby \
#   ruby-dev

# Install go
COPY --from=golang $GO_DIR $GO_DIR
ENV PATH=$PATH:$GO_DIR/bin

# Install build tools
RUN apk add --no-cache \
  build-base \
  curl \
  wget \
  unzip \
  gzip \
  bash

# Install telescope dependencies
RUN apk add --no-cache \
  ripgrep \
  fd \
  git

# Install glow from alpine/edge/testing
# CLI Markdown reader
# https://github.com/charmbracelet/glow
RUN apk add --no-cache --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing \
  glow

COPY --from=treesitter /root/.cargo/bin/tree-sitter /usr/local/bin
COPY --from=lua-language-server "lua-language-server/bin/lua-language-server" /usr/local/bin
COPY --from=neovim /tmp/nvim_dist/usr/local /usr/local

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
  +"MasonInstall marksman" \
  +"MasonInstall svelte-language-server" \
  +"MasonInstall vtsls" \
  +"MasonInstall taplo yaml-language-server" \
  +qa
