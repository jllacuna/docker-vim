#
# Stage: base
#
FROM --platform=linux/amd64 jllacuna/nvim AS cache
FROM --platform=linux/amd64 golang:alpine AS golang
# glibc needed for tree-sitter-cli
FROM --platform=linux/amd64 frolvlad/alpine-glibc:alpine-3.20 AS base

ARG NVIM_CONFIG_PATH=/root/.config
ARG GO_DIR=/usr/local/go
ARG LSP_SERVERS=/usr/local/lib/lsp_servers
ARG PARSER_DIR=/usr/local/lib/treesitter_parsers
ARG MASON_DIR=/usr/local/lib/mason

# Install neovim with docs
RUN apk add --no-cache \
  neovim \
  neovim-doc

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
  curl

# Install telescope dependencies
RUN apk add --no-cache \
  ripgrep \
  fd \
  git

# Install tree-sitter
RUN npm install -g \
  tree-sitter-cli

# Install glow from alpine/edge/testing
# CLI Markdown reader
# https://github.com/charmbracelet/glow
RUN apk add --no-cache --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing \
  glow

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
  +"MasonInstall json-lsp css-lsp html-lsp" \
  +"MasonInstall vtsls" \
  +"MasonInstall yaml-language-server" \
  +"MasonInstall dockerfile-language-server" \
  +"MasonInstall svelte-language-server" \
  +"MasonInstall gopls" \
  +"MasonInstall pyright" \
  +"MasonInstall solargraph" \
  +"MasonInstall rnix-lsp" \
  +qa
