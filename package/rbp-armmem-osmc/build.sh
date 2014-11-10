# (c) 2014 Sam Nazarko
# email@samnazarko.co.uk

#!/bin/bash

. ../common.sh

echo -e "Building package rbp-armmem"
out=$(pwd)/files
make clean
pull_source "https://github.com/bavison/arm-mem" "$(pwd)/src"
cd src
make
if [ $? != 0 ]; then echo "Error occured during build" && exit 1; fi
strip_libs
mkdir -p $out/usr/lib
cp -ar libarmmem.so $out/usr/lib
cp -ar libarmmem.a $out/usr/lib
cd ../
dpkg -b files/ rbp-armmem-osmc.deb
