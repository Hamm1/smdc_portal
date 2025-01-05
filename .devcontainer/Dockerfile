#Debian Build

FROM ubuntu:24.04
RUN apt update
RUN apt install curl unzip zsh git libdbus-1-dev pkg-config \
                libwebkit2gtk-4.1-dev \
                zlib1g libevent-dev libicu-dev \
                build-essential wget libssl-dev software-properties-common \
                libnss3-dev libgdk-pixbuf2.0-dev libxss-dev\
                libgtk-3-dev libsoup-3.0-dev libjavascriptcoregtk-4.1-dev \
                librsvg2-dev libfuse2 libappindicator3-dev libwebkit2gtk-4.1-dev \
                patchelf python3-requests python3-apt python3.13-venv python3-pip \
                apt-transport-https ca-certificates gnupg lsb-release -y
RUN curl -fsSL https://bun.sh/install | bash
RUN curl -fsSL https://deno.land/x/install/install.sh | sh
RUN curl -SLO https://deb.nodesource.com/nsolid_setup_deb.sh; rm -f /usr/share/keyrings/nodesource.gpg; chmod 500 nsolid_setup_deb.sh; ./nsolid_setup_deb.sh 23; apt-get install nodejs -y; rm -f ./nsolid_setup_deb.sh
RUN curl -L https://dl.dagger.io/dagger/install.sh | BIN_DIR=$HOME/.local/bin sh
RUN curl https://sh.rustup.rs --output ./rust.sh;chmod +x ./rust.sh;./rust.sh -y;rm ./rust.sh


ARG POWERSHELL_VERSION=7.4.6
ARG POWERSHELL_DEP=libicu74_74.2-1ubuntu4_amd64.deb
RUN wget https://mirror.it.ubc.ca/ubuntu/pool/main/i/icu/$POWERSHELL_DEP
RUN dpkg -i $POWERSHELL_DEP
RUN wget https://github.com/PowerShell/PowerShell/releases/download/v$POWERSHELL_VERSION/powershell_$POWERSHELL_VERSION-1.deb_amd64.deb
RUN dpkg -i powershell_$POWERSHELL_VERSION-1.deb_amd64.deb
RUN apt-get install -f -y
RUN rm powershell_$POWERSHELL_VERSION-1.deb_amd64.deb

ARG DEBIAN_FRONTEND=noninteractive

RUN curl https://starship.rs/install.sh --output ./starship.sh;chmod +x ./starship.sh;./starship.sh -y;rm ./starship.sh
RUN curl https://raw.githubusercontent.com/Hamm1/devbox/main/zshrc --output ~/.zshrc
RUN git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
# RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
# RUN echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
# RUN apt-get update
# RUN apt-get install -y docker-ce docker-ce-cli containerd.io
RUN chsh -s $(which zsh)

WORKDIR /root
