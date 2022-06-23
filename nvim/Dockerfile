FROM alpine:3.16 AS base

# Install neovim with docs
RUN apk add --no-cache \
  neovim \
  neovim-doc

# Install nodejs and npm
RUN apk add --no-cache \
  nodejs \
  npm

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

RUN npm install -g \
  # Install html, css, json, eslint language servers 
  vscode-langservers-extracted \
  typescript typescript-language-server \
  yaml-language-server \
  dockerfile-language-server-nodejs \
  svelte-language-server \
  tree-sitter-cli

WORKDIR /data

ENTRYPOINT [ "nvim" ]

FROM base AS cached

ARG PARSER_DIR=/usr/local/lib/treesitter_parsers

# Copy treesitter parsers from existing image to avoid their build time
COPY --from=jllacuna/nvim $PARSER_DIR $PARSER_DIR

# Copy neovim config to root home
COPY config /root/.config

# Install plugins with packer.nvim
RUN apk add --no-cache --virtual .deps build-base \
  && nvim --headless -c 'autocmd User PackerComplete quitall' \
  && apk del .deps

FROM base AS not_cached

# Copy neovim config to root home
COPY config /root/.config

# Install plugins with packer.nvim
RUN apk add --no-cache --virtual .deps build-base \
  && nvim --headless -c 'autocmd User PackerComplete quitall' \
  && apk del .deps
