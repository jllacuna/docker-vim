#
# Stage: base
#
FROM --platform=linux/amd64 jllacuna/nvim AS cache
FROM --platform=linux/amd64 golang:alpine AS golang
FROM --platform=linux/amd64 alpine:3.16 AS base

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
ARG GO_DIR=/usr/local/go
COPY --from=golang $GO_DIR $GO_DIR
ENV PATH=$PATH:$GO_DIR/bin

# Install telescope dependencies
RUN apk add --no-cache \
  ripgrep \
  fd \
  git

# Install glibc for tree-sitter-cli
ARG GLIBC_REPO=https://github.com/sgerrand/alpine-pkg-glibc
ARG GLIBC_VERSION=2.30-r0

RUN set -ex && \
  apk add --no-cache --virtual .deps libstdc++ curl ca-certificates && \
  for pkg in glibc-${GLIBC_VERSION} glibc-bin-${GLIBC_VERSION}; \
      do curl -sSL ${GLIBC_REPO}/releases/download/${GLIBC_VERSION}/${pkg}.apk -o /tmp/${pkg}.apk; done && \
  apk add --allow-untrusted /tmp/*.apk && \
  rm -v /tmp/*.apk && \
  /usr/glibc-compat/sbin/ldconfig /lib /usr/glibc-compat/lib \
  && apk del .deps

# Folder for lsp servers
ENV LSP_SERVERS=/usr/local/lib/lsp_servers
RUN mkdir -p $LSP_SERVERS

# Install lua-language-server
RUN apk add --no-cache --virtual .deps build-base bash ninja \
  && cd $LSP_SERVERS \
  && git clone --depth=1 https://github.com/sumneko/lua-language-server \
  && cd lua-language-server \
  && git submodule update --depth 1 --init --recursive \
  && cd 3rd/luamake \
  && ./compile/install.sh \
  && cd ../.. \
  && ./3rd/luamake/luamake rebuild \
  && ln -s ../lib/lsp_servers/lua-language-server/bin/lua-language-server /usr/local/bin \
  && apk del .deps

# Install gopls (go language server)
ENV PATH=$PATH:$LSP_SERVERS/go/bin
RUN go install golang.org/x/tools/gopls@latest \
  && mv /root/go $LSP_SERVERS

# Install solargraph (ruby language server)
RUN apk add --no-cache --virtual .deps build-base \
  && gem install solargraph \
  && apk del .deps

# Install various language servers with node/npm
RUN npm install -g \
  # Install html, css, json, eslint language servers 
  vscode-langservers-extracted \
  typescript typescript-language-server \
  yaml-language-server \
  dockerfile-language-server-nodejs \
  svelte-language-server \
  tree-sitter-cli \
  @lifeart/ember-language-server \
  pyright

# Install glow from alpine/edge/testing
# CLI Markdown reader
# https://github.com/charmbracelet/glow
RUN apk add --no-cache --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing \
  glow

# Set GOPATH to our volumed workspace
# Allows gopls to reference our imported modules
ENV GOPATH=/workspace/go

# Set XDG_CACHE_HOME for lewis6991/impatient.nvim plugin
ENV XDG_CACHE_HOME=/usr/local/lib/xdg

WORKDIR /data

ENTRYPOINT [ "nvim" ]

#
# Stage: cached
#
FROM base AS cached

ARG PARSER_DIR=/usr/local/lib/treesitter_parsers

# Copy treesitter parsers from existing image to avoid their build time
COPY --from=cache $PARSER_DIR $PARSER_DIR

# Copy neovim config to root home
COPY config /root/.config

# Install plugins with packer.nvim
RUN apk add --no-cache --virtual .deps build-base \
  && nvim --headless -c 'autocmd User PackerComplete quitall' \
  && apk del .deps

# Prime plugin cache for lewis6991/impatient.nvim
RUN nvim --headless -c 'quitall'

#
# Stage: not_cached
#
FROM base AS not_cached

# Copy neovim config to root home
COPY config /root/.config

# Install plugins with packer.nvim
RUN apk add --no-cache --virtual .deps build-base \
  && nvim --headless -c 'autocmd User PackerComplete quitall' \
  && apk del .deps

# Prime plugin cache for lewis6991/impatient.nvim
RUN nvim --headless -c 'quitall'
