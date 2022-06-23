FROM alpine:3.16

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

# Install html, css, json, eslint language servers
RUN npm install -g vscode-langservers-extracted \
  typescript typescript-language-server \
  yaml-language-server \
  dockerfile-language-server-nodejs \
  svelte-language-server

# Copy neovim config to root home
COPY config /root/.config

# Install plugins with packer.nvim
RUN apk add --no-cache --virtual .deps build-base \
  && nvim --headless -c 'autocmd User PackerComplete quitall' \
  && apk del .deps

WORKDIR /data

ENTRYPOINT [ "nvim" ]
