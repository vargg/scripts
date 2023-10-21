#!/bin/bash


if [[ -f /etc/os-release ]]; then
    source /etc/os-release
    OS_RELEASE=$ID
elif [[ -f /usr/lib/os-release ]]; then
    source /usr/lib/os-release
    OS_RELEASE=$ID
else
    echo "Failed to check the system OS" >&2
    exit 1
fi

INCLUDE_GMOME=$INCLUDE_GMOME
INCLUDE_SNAP=$INCLUDE_SNAP

if [[ $OS_RELEASE == "ubuntu" ]]; then
    # firefox
    sudo snap remove --purge firefox && sudo apt remove --autoremove firefox
    sudo add-apt-repository ppa:mozillateam/ppa && sudo gpg \
        --homedir /tmp --no-default-keyring --keyring /etc/apt/keyrings/mozillateam.gpg \
        --keyserver [keyserver.ubuntu.com](http://keyserver.ubuntu.com/) --recv-keys 0AB215679C571D1C8325275B9BDB3D89CE49EC21
    echo '
    Package: *firefox
    Pin: release o=LP-PPA-mozillateam
    Pin-Priority: 501

    Package: firefox*
    Pin: release o=Ubuntu
    Pin-Priority: -1
    ' | sudo tee /etc/apt/preferences.d/mozilla-firefox | sudo tee /etc/apt/preferences.d/99mozillateamppa
fi

# vscode
wget -qO - [https://packages.microsoft.com/keys/microsoft.asc](https://packages.microsoft.com/keys/microsoft.asc) | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] [https://packages.microsoft.com/repos/code](https://packages.microsoft.com/repos/code) stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg

# spotify
wget -nv -4O - https://download.spotify.com/debian/pubkey_7A3A762FAFD4A51F.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list

# keepass
sudo add-apt-repository ppa:phoerious/keepassxc

sudo apt update
sudo apt install \
    blueman \
    curl \
    git \
    htop \
    vim \
    wireguard \
    transmission \
    vlc \
    firefox \
    guake \
    chromium-browser \
    apt-transport-https code \
    spotify-client \
    virtualbox virtualbox—ext–pack \
    keepassxc \
    telegram-desktop

# pyenv / python
sudo apt install \
    build-essential \
    libssl-dev \
    libreadline-dev \
    libbz2-dev \
    libffi-dev \
    libsqlite3-dev \
    liblzma-dev \
    zlib1g-dev \
    python-tk python3-tk tk-dev

# anki
# docker
# firecamp
# pyenv
# skype
# sunflower
# zoom

if [[ ! -z $INCLUDE_GMOME ]]; then
    sudo apt install \
        gnome-shell-extension-manager \
        gnome-tweaks \
    # gnome-shell-extensions:
    #   - clipboard -ndicator
    #   - cronomix
    #   - gtile
    #   - lock keys
fi

if [[ ! -z $INCLUDE_SNAP ]]; then
    sudo snap install \
        notion-snap \
        twinux
fi
