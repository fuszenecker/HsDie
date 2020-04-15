rm -rf debs
mkdir debs
find -L ~/dev | egrep  "\.deb$" | xargs -I _ cp _ debs

dpkg-sig -k F20 --sign repo debs/*.deb

dpkg-scanpackages debs > Packages
gzip -fk9 Packages

apt-ftparchive release . > Release

rm -fr InRelease
gpg --default-key F20 --clearsign -o InRelease Release
