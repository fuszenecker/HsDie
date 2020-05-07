#!/bin/sh

# Variables
SOURCE_FOLDER=~/dev
PACKAGES_FOLDER=debs
REPO_NAME=myrepo
SIGN_KEY=F20

echo "---- Finding packages ----"
rm -rf debs
mkdir debs
find -L $SOURCE_FOLDER | egrep  "\.deb$" | xargs -I _ cp _ $PACKAGES_FOLDER

echo
echo "---- Signing packages ----"

dpkg-sig -k $SIGN_KEY --sign $REPO_NAME $PACKAGES_FOLDER/*.deb

echo
echo "---- Creating Packages file ----"

dpkg-scanpackages $PACKAGES_FOLDER > Packages
gzip -fk9 Packages

echo
echo "---- Creating Release file ----"

apt-ftparchive release . > Release

echo
echo "---- Creating InRelease by signing Release file ----"

rm -fr InRelease
gpg --default-key $SIGN_KEY --clearsign -o InRelease Release

echo
echo "Done."
