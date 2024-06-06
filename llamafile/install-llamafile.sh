#!/bin/bash

# Script to install llamafile from source
# Useage: ./llamafile-installer.sh

LLAMAFILE_VERSION=$(llamafile --version 2>/dev/null)

# If llamafile is not installed, install it
if [ $? -ne 0 ]; then
    echo "Configuring llamafile permissions..."
    sudo wget -O /usr/bin/ape https://cosmo.zip/pub/cosmos/bin/ape-$(uname -m).elf
    sudo chmod +x /usr/bin/ape
    sudo sh -c "echo ':APE:M::MZqFpD::/usr/bin/ape:' >/proc/sys/fs/binfmt_misc/register"
    sudo sh -c "echo ':APE-jart:M::jartsr::/usr/bin/ape:' >/proc/sys/fs/binfmt_misc/register"

    echo "Building llamafile from source..."
    git clone https://github.com/Mozilla-Ocho/llamafile.git
    cd llamafile
    make -j8
    sudo make install PREFIX=/usr/local
    
    echo "Successfully installed $(llamafile --version)"
    echo "Recommended for WSL: sudo sh -c 'echo -1 > /proc/sys/fs/binfmt_misc/WSLInterop'"
else
    echo "${LLAMAFILE_VERSION} already installed"
fi

