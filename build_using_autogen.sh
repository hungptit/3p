#!/bin/bash
EXTERNAL_FOLDER=$PWD
SRC_FOLDER=$EXTERNAL_FOLDER/src
TMP_FOLDER=/tmp/build/

mkdir -p $TMP_FOLDER
mkdir -p $SRC_FOLDER

NCPUS=$(grep -c ^processor /proc/cpuinfo)
BUILD_OPTS=-j$((NCPUS+1))

# Setup git
GIT_PREFIX=$EXTERNAL_FOLDER/git
GIT=$GIT_PREFIX/bin/git
if [ ! -f $GIT ]; then
    GIT=git
fi

# Build given package
PKGNAME=$1
PKGGIT=$2
EXTRA_CONFIG_OPTIONS=$3
EXTRA_MAKE_OPTIONS=$4
EXTRA_INSTALL_OPTIONS=$5

APKG_SRC=$SRC_FOLDER/$PKGNAME
APKG_BUILD_FOLDER=$APKG_SRC/build
APKG_PREFIX=$EXTERNAL_FOLDER/$PKGNAME

echo "Src folder: " $APKG_SRC
echo "Build folder: " $APKG_BUILD_FOLDER
echo "Prefix folder: " $APKG_PREFIX

echo "Extra config options: " $EXTRA_CONFIG_OPTIONS
echo "Extra make options: " $EXTRA_MAKE_OPTIONS
echo "Extra installation options: " $EXTRA_INSTALL_OPTIONS

cd $SRC_FOLDER
if [ ! -d $APKG_SRC ]; then
    $GIT clone $PKGGIT $PKGNAME
fi

# Pull the latest version
cd $APKG_SRC
$GIT pull

# Build a given package
cd $APKG_SRC
./autogen.sh                    # Generate Makefile
$APKG_SRC/configure --prefix=$APKG_PREFIX $EXTRA_CONFIG_OPTIONS
make $BUILD_OPTS $EXTRA_MAKE_OPTIONS
rm -rf $APKG_PREFIX
make install
