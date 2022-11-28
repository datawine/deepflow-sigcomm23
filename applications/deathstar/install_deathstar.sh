#!/bin/sh

pushd .

cd ~

rm DeathStar_0.0.1-beta.1_linux_amd64.zip

mkdir -p deathstar

wget https://github.com/djmgit/DeathStar/releases/download/v0.0.1-beta.1/DeathStar_0.0.1-beta.1_linux_amd64.zip --directory-prefix=deathstar

unzip deathstar/DeathStar_0.0.1-beta.1_linux_amd64.zip -d deathstar

sudo cp deathstar/DeathStar /usr/local/bin/

rm -rf deathstar

echo "DeathStar is installed."

popd > /dev/null