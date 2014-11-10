# (c) 2014 Sam Nazarko
# email@samnazarko.co.uk

#!/bin/bash

. ../common.sh

echo -e "Building libnfs"
out=$(pwd)/files
if [ -d files/usr ]; then rm -rf files/usr; fi
if [ -d files-dev/usr ]; then rm -rf files-dev/usr; fi
sed '/Package/d' -i files/DEBIAN/control
sed '/Package/d' -i files-dev/DEBIAN/control
sed '/Depends/d' -i files-dev/DEBIAN/control
test "$1" == gen && echo "Package: libnfs-osmc" >> files/DEBIAN/control && echo "Package: libnfs-dev-osmc" >> files-dev/DEBIAN/control && echo "Depends: libnfs-osmc" >> files-dev/DEBIAN/control
test "$1" == rbp && echo "Package: rbp-libnfs-osmc" >> files/DEBIAN/control && echo "Package: rbp-libnfs-dev-osmc" >> files-dev/DEBIAN/control && echo "Depends: rbp-libnfs-osmc" >> files-dev/DEBIAN/control
pull_source "https://github.com/sahlberg/libnfs/" "$(pwd)/src"
cd src
git checkout libnfs-1.9.5
./bootstrap
./configure --prefix=/usr
$BUILD
make install DESTDIR=${out}
if [ $? != 0 ]; then echo "Error occured during build" && exit 1; fi
strip_files "${out}"
cd ../
mkdir -p files-dev/usr
mv files/usr/include  files-dev/usr/
fix_arch_ctl "files/DEBIAN/control"
fix_arch_ctl "files-dev/DEBIAN/control"
dpkg -b files libnfs-osmc.deb
dpkg -b files-dev libnfs-dev-osmc.deb

