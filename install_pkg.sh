#!/bin/bash
EXTERNAL_FOLDER=$1
PKG_NAME=$2
PKGGIT=$3
SRC_FOLDER=$4
PKG_SRC=$SRC_FOLDER/$PKG_NAME
TMP_FOLDER=/tmp/build/

echo $EXTERNAL_FOLDER
echo $PKG_NAME
echo $PKGGIT

mkdir -p $TMP_FOLDER
mkdir -p $SRC_FOLDER

NCPUS=$(grep -c ^processor /proc/cpuinfo)
BUILD_OPTS=-j$((NCPUS+1))

# Setup git
GIT_PREFIX=$EXTERNAL_FOLDER/git
GIT=$GIT_PREFIX/bin/git
if [ ! -f $GIT ]; then
    # Use system CMake if we could not find the customized CMake.
    GIT=git
fi

# Build given package
cd $SRC_FOLDER
if [ ! -d $PKG_SRC ]; then
    $GIT clone $PKGGIT $PKG_NAME
fi

# Pull the latest version
cd $PKG_SRC
$GIT pull
