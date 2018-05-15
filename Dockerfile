FROM ubuntu:16.04

MAINTAINER Jay Llacuna

ENV REFRESHED_AT 2018-05-09

# Install vim from source
RUN apt-get -yqq update
RUN apt-get -yqq install libncurses5-dev \
                         libgnome2-dev \
                         libgnomeui-dev \
                         libgtk2.0-dev \
                         libatk1.0-dev \
                         libbonoboui2-dev \
                         libcairo2-dev \
                         libx11-dev \
                         libxpm-dev \
                         libxt-dev \
                         python-dev \
                         python3-dev \
                         ruby-dev \
                         lua5.1 \
                         liblua5.1-dev \
                         libperl-dev \
                         git \
                         curl

ENV INSTALLS /root/installs

RUN mkdir -p $INSTALLS

RUN git clone https://github.com/vim/vim.git $INSTALLS/vim
RUN cd $INSTALLS/vim && git pull && \
    ./configure --with-features=huge \
                --enable-multibyte \
                --enable-rubyinterp=yes \
                --enable-pythoninterp=yes \
                --enable-python3interp=yes \
                --enable-perlinterp=yes \
                --enable-luainterp=yes \
                --enable-gui=gtk2 \
                --enable-cscope \
                --prefix=/usr/local && \
    make && \
    make install

# Install pathogen
RUN mkdir -p ~/.vim/autoload ~/.vim/bundle ~/.vim/colors
RUN curl -LSso ~/.vim/autoload/pathogen.vim https://raw.githubusercontent.com/tpope/vim-pathogen/master/autoload/pathogen.vim

# Install jellybeans color scheme
RUN curl -LSso ~/.vim/colors/jellybeans.vim https://raw.githubusercontent.com/nanotech/jellybeans.vim/master/colors/jellybeans.vim

# ---------------
# Install plugins
# ---------------

# CoffeeTags
RUN gem install CoffeeTags
RUN git clone https://github.com/lukaszkorecki/CoffeeTags.git ~/.vim/bundle/CoffeeTags

# Dockerfile
RUN git clone https://github.com/ekalinin/Dockerfile.vim.git ~/.vim/bundle/Dockerfile

# ag.vim
RUN apt-get -yqq install silversearcher-ag
RUN git clone https://github.com/rking/ag.vim.git ~/.vim/bundle/ag.vim

# ctrlp.vim
RUN git clone https://github.com/ctrlpvim/ctrlp.vim.git ~/.vim/bundle/ctrlp.vim

# html5.vim
RUN git clone https://github.com/othree/html5.vim.git ~/.vim/bundle/html5.vim

# simple-pairs
RUN git clone https://github.com/vim-scripts/simple-pairs.git ~/.vim/bundle/simple-pairs

# tabular
RUN git clone https://github.com/godlygeek/tabular.git ~/.vim/bundle/tabular

# tagbar
RUN apt-get -yqq install exuberant-ctags
RUN git clone https://github.com/majutsushi/tagbar.git ~/.vim/bundle/tagbar

# tcomment_vim
RUN git clone https://github.com/tomtom/tcomment_vim.git ~/.vim/bundle/tcomment_vim

# thor.vim
RUN git clone https://github.com/smallspark/thor.vim.git ~/.vim/bundle/thor.vim

# ultisnips
RUN git clone https://github.com/SirVer/ultisnips.git ~/.vim/bundle/ultisnips

# vim-airline
RUN apt-get -yqq install locales fontconfig
RUN locale-gen en_US.UTF-8 && \
    /usr/sbin/update-locale LANG=en_US.UTF-8
ENV LC_ALL en_US.UTF-8

RUN mkdir -p ~/.fonts ~/.config/fontconfig/conf.d && \
  curl -LSso ~/.fonts/PowerlineSymbols.otf https://github.com/powerline/powerline/raw/develop/font/PowerlineSymbols.otf && \
  curl -LSso ~/.config/fontconfig/conf.d/10-powerline-symbols.conf https://github.com/powerline/powerline/raw/develop/font/10-powerline-symbols.conf && \
  fc-cache -vf ~/.fonts

RUN git clone https://github.com/bling/vim-airline.git ~/.vim/bundle/vim-airline
RUN git clone https://github.com/vim-airline/vim-airline-themes.git ~/.vim/bundle/vim-airline-themes

# vim-bundler
RUN git clone https://github.com/tpope/vim-bundler.git ~/.vim/bundle/vim-bundler

# vim-coffee-script
RUN git clone https://github.com/kchmck/vim-coffee-script.git ~/.vim/bundle/vim-coffee-script

# vim-fugitive
RUN git clone https://github.com/tpope/vim-fugitive.git ~/.vim/bundle/vim-fugitive

# Install go
ENV GO_VERSION=1.10.2
RUN mkdir -p $INSTALLS/golang
RUN curl -LSso $INSTALLS/golang/go$GO_VERSION.linux-amd64.tar.gz https://storage.googleapis.com/golang/go$GO_VERSION.linux-amd64.tar.gz
RUN tar -C /usr/local -xzf $INSTALLS/golang/go$GO_VERSION.linux-amd64.tar.gz
ENV PATH $PATH:/usr/local/go/bin

# vim-go
RUN git clone https://github.com/fatih/vim-go.git ~/.vim/bundle/vim-go

# vim-haml
RUN git clone https://github.com/tpope/vim-haml.git ~/.vim/bundle/vim-haml

# vim-jade
RUN git clone https://github.com/digitaltoad/vim-jade.git ~/.vim/bundle/vim-jade

# vim-javascript
RUN git clone https://github.com/pangloss/vim-javascript.git ~/.vim/bundle/vim-javascript

# vim-jsx
RUN git clone https://github.com/mxw/vim-jsx.git ~/.vim/bundle/vim-jsx

# vim-jst
RUN git clone https://github.com/briancollins/vim-jst.git ~/.vim/bundle/vim-jst

# vim-markdown
RUN git clone https://github.com/tpope/vim-markdown.git ~/.vim/bundle/vim-markdown

# vim-rails
RUN git clone https://github.com/tpope/vim-rails.git ~/.vim/bundle/vim-rails

# vim-raml
RUN git clone https://github.com/kennethzfeng/vim-raml.git ~/.vim/bundle/vim-raml

# vim-rspec
RUN git clone https://github.com/thoughtbot/vim-rspec.git ~/.vim/bundle/vim-rspec

# vim-ruby
RUN git clone https://github.com/vim-ruby/vim-ruby.git ~/.vim/bundle/vim-ruby

# vim-snippets
RUN git clone https://github.com/honza/vim-snippets.git ~/.vim/bundle/vim-snippets

# vim-sparkup
RUN git clone https://github.com/tristen/vim-sparkup.git ~/.vim/bundle/vim-sparkup

# vim-surround
RUN git clone https://github.com/tpope/vim-surround.git ~/.vim/bundle/vim-surround

# vim-textobj-rubyblock
RUN git clone https://github.com/nelstrom/vim-textobj-rubyblock.git ~/.vim/bundle/vim-textobj-rubyblock

# vim-textobj-user
RUN git clone https://github.com/kana/vim-textobj-user.git ~/.vim/bundle/vim-textobj-user

# vim-bind (i.e. DNS zone files)
RUN git clone https://github.com/Absolight/vim-bind.git ~/.vim/bundle/vim-bind

# Install node 10
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get -yqq install nodejs

# YouCompleteMe
# NOTE: Building this may result in virtual memory limitations
# Add swap space to docker-machine to compile
# SSH to the docker machine: docker-machine ssh
# Add swap to docker machine: http://stackoverflow.com/a/31141359
RUN apt-get -yqq install build-essential cmake
RUN git clone https://github.com/Valloric/YouCompleteMe.git ~/.vim/bundle/YouCompleteMe
RUN cd ~/.vim/bundle/YouCompleteMe && git submodule update --init --recursive
RUN cd ~/.vim/bundle/YouCompleteMe && ./install.py --clang-completer --go-completer --js-completer

# https://github.com/ryanoasis/vim-devicons#quick-installation
# NOTE: Need to install a patched Nerd Font: https://github.com/ryanoasis/nerd-fonts#usage
RUN git clone https://github.com/ryanoasis/vim-devicons ~/.vim/bundle/vim-devicons

# Add our vimrc
ADD vimrc /root/.vimrc

# Set up a volume to work in
VOLUME /data
WORKDIR /data

ENTRYPOINT [ "vim" ]
