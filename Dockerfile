FROM ubuntu:bionic

RUN mkdir -p /root/.bin && touch /root/.zshrc

RUN apt update && apt upgrade -y && apt install -y \
  git \
  exuberant-ctags \
  neovim \
  python3-pip \
  software-properties-common \
  wget \
  zsh

RUN chsh -s $(which zsh)

RUN add-apt-repository ppa:martin-frost/thoughtbot-rcm \
    && apt update \
    && apt install rcm -y
 

RUN git clone https://github.com/thinktandem/dotfiles.git ~/dotfiles \
    && mkdir -p ${XDG_CONFIG_HOME:=$HOME/.config} \
    && mkdir -p $XDG_CONFIG_HOME/nvim \
    && ln -s ~/.vim/autoload ~/.config/nvim/ \
    && ln -s ~/.vimrc $XDG_CONFIG_HOME/nvim/init.vim \
    && rcup 

RUN git clone https://github.com/nodenv/nodenv.git ~/.nodenv

RUN git clone \
    https://github.com/nodenv/node-build.git \
    /root/.nodenv/plugins/node-build

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt remove cmdtest \
    && apt update \
    && apt install --no-install-recommends yarn -y

RUN add-apt-repository ppa:cpick/hub \
    && apt update \
    && apt install -y hub

RUN apt remove docker docker-engine docker.io \
    && apt install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
    | apt-key add - \
    && add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    bionic \
    stable" \
    && apt update \
    && apt install -y docker-ce

RUN TEMP_DEB="$(mktemp)" \
    && wget -O "$TEMP_DEB" \
    'https://github.com/lando/lando/releases/download/v3.0.0-rc.1/lando-v3.0.0-rc.1.deb' \
    && dpkg -i "$TEMP_DEB" \
    && rm -f "$TEMP_DEB"
RUN curl -L git.io/antigen > ~/antigen.zsh
RUN RCRC=$HOME/dotfiles/rcrc rcup 
CMD ["/usr/bin/zsh"]
