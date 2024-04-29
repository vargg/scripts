#!/bin/bash

set -e

if [[ -f /etc/os-release ]]; then
    source /etc/os-release
elif [[ -f /usr/lib/os-release ]]; then
    source /usr/lib/os-release
fi

RELEASE_ID=$ID
RELEASE_CODENAME=$VERSION_CODENAME
ARCHITECTURE=$(dpkg --print-architecture)

if [[ $RELEASE_ID != "ubuntu" ]]; then
    echo "Failed to check the system OS" >&2
    exit 1
fi

PACKAGE="deb"
GPG_KEYS_DIR="/etc/apt/keyrings"
SOURCES_LIST_DIR="/etc/apt/sources.list.d"

# replace snap firefox
sudo snap remove --purge firefox
sudo apt remove --autoremove firefox
sudo add-apt-repository ppa:mozillateam/ppa
sudo gpg \
    --homedir /tmp \
    --no-default-keyring \
    --keyring /etc/apt/keyrings/mozillateam.gpg \
    --keyserver http://keyserver.ubuntu.com/ \
    --recv-keys 0AB215679C571D1C8325275B9BDB3D89CE49EC21

echo '
Package: *firefox
Pin: release o=LP-PPA-mozillateam
Pin-Priority: 501

Package: firefox*
Pin: release o=Ubuntu
Pin-Priority: -1
' | sudo tee /etc/apt/preferences.d/mozilla-firefox | sudo tee /etc/apt/preferences.d/99mozillateamppa

sudo apt install -y wget gpg gnupg ca-certificates gcc


add_repo() {
    REPO_NAME=$1
    GPG_KEY_URL=$2
    REPO_URL=$3
    DISTRIBUTION=$4
    COMPONENT=$5

    GPG_KEY_PATH="$GPG_KEYS_DIR/$REPO_NAME.gpg"

    wget --quiet -4O - $GPG_KEY_URL \
        | sudo gpg --dearmor --yes -o $GPG_KEY_PATH

    echo "$PACKAGE [arch=$ARCHITECTURE signed-by=$GPG_KEY_PATH] $REPO_URL $DISTRIBUTION $COMPONENT" \
        | sudo tee "$SOURCES_LIST_DIR/$REPO_NAME.list"
}


add_repo \
    "vscode" \
    "https://packages.microsoft.com/keys/microsoft.asc" \
    "https://packages.microsoft.com/repos/code" \
    "stable" \
    "main"

add_repo \
    "vscodium" \
    "https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg" \
    "https://download.vscodium.com/debs" \
    "vscodium" \
    "main"

add_repo \
    "spotify" \
    "https://download.spotify.com/debian/pubkey_7A3A762FAFD4A51F.gpg" \
    "http://repository.spotify.com" \
    "stable" \
    "non-free"

add_repo \
    "docker" \
    "https://download.docker.com/linux/ubuntu/gpg" \
    "https://download.docker.com/linux/ubuntu" \
    $RELEASE_CODENAME \
    "stable"

add_repo \
    "beekeeper" \
    "https://deb.beekeeperstudio.io/beekeeper.key" \
    "https://deb.beekeeperstudio.io" \
    "stable" \
    "main"

sudo add-apt-repository ppa:phoerious/keepassxc

sudo apt update
sudo apt install -y \
    curl \
    git \
    htop \
    vim \
    guake \
    transmission \
    vlc \
    firefox \
    thunderbird \
    apt-transport-https code \
    spotify-client \
    keepassxc \
    beekeeper-studio \
    translate-shell

# docker
sudo apt install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin
sudo usermod -aG docker $USER

# python / pyenv
sudo apt install -y \
    build-essential \
    libssl-dev \
    libreadline-dev \
    libbz2-dev \
    libffi-dev \
    libsqlite3-dev \
    liblzma-dev \
    zlib1g-dev \
    python3-tk tk-dev
curl https://pyenv.run | bash

echo '
# PYENV
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

eval "$(pyenv virtualenv-init -)"' >> ~/.bashrc

echo '
# PYENV
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
' >> ~/.profile

# anki
# httpie
# nekoray
# onedriver
# sunflower

sudo apt install \
    gnome-shell-extension-manager \
    gnome-tweaks

sudo snap install \
    chromium \
    httpie \
    logseq \
    notion-snap-reborn \
    telegram-desktop \
    twinux
