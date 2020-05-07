#!/usr/bin/env sh


mkdir -p packaging/usr/bin
cabal --installdir=packaging/usr/bin --overwrite-policy=always --install-method=copy install

if [ -x /usr/bin/upx ]; then
    upx -9 packaging/usr/bin/die
fi

dpkg-deb -b packaging die.armhf.deb

