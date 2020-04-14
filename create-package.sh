#!/usr/bin/env sh

stack install --system-ghc

mkdir -p packaging/usr/bin
cp ~/.local/bin/die packaging/usr/bin

if [ -x /usr/bin/upx ]; then
    upx -9 packaging/usr/bin/die
fi

dpkg-deb -b packaging die.armhf.deb

