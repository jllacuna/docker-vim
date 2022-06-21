FROM alpine:3.16

# Install neovim with docs
RUN apk add --no-cache \
  neovim \
  neovim-doc

# Copy neovim config to root home
COPY config /root/.config

# Install git
# Install plugins with packer.nvim
# Clean up git for a smaller image
# TODO: Probably need git later
RUN apk add --no-cache --virtual .deps git \
  && nvim --headless -c 'autocmd User PackerComplete quitall' \
  && apk del .deps

WORKDIR /data

ENTRYPOINT [ "nvim" ]
