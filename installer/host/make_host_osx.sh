# (c) 2014 Sam Nazarko
# email@samnazarko.co.uk

#!/bin/bash
echo Building host installer for OS X

TARGET="qt_host_installer"
RESOURCES=resources
ICONDIR=${RESOURCES}/app.iconset
ICONSET_NAME="logo.icns"

pushd ${TARGET}
if [ -f Makefile ]; then echo "Cleaning" && make clean; fi
rm -rf ${TARGET}.app
echo Building installer
qmake -spec macx-g++
make
if [ $? != 0 ]; then echo "Build failed" && exit 1; fi

cp ${RESOURCES}/Info.plist ${TARGET}.app/Contents/

## handle application icons
echo handling application icons
rm ${RESOURCES}/${ICONSET_NAME}
iconutil -c icns --output ${RESOURCES}/${ICONSET_NAME} ${ICONDIR}
cp ${RESOURCES}/${ICONSET_NAME} ${TARGET}.app/Contents/Resources/
sed -e s/ICON_HERE/${ICONSET_NAME}/ -i old ${TARGET}.app/Contents/Info.plist
echo Placing Version

## try to set version in plist
VERSION=$(cat ${TARGET}.pro | grep VERSION | tail -n 1 | awk {'print $3'})
sed -e s/VERVAL/${VERSION}/ -i old ${TARGET}.app/Contents/Info.plist

echo Packaging installer
macdeployqt ${TARGET}.app -dmg -no-plugins
popd
mv ${TARGET}/${TARGET}.dmg osmc-installer.dmg
echo Build complete
