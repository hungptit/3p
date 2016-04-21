#!/bin/bash
EXTERNAL_FOLDER=$1
PKGNAME=$2
PKGGIT=$3
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
    # Use system CMake if we could not find the customized CMake.
    GIT=git
fi

# Build given package
APKG_PREFIX=$EXTERNAL_FOLDER/$PKGNAME
cd $EXTERNAL_FOLDER
if [ ! -d $APKG_PREFIX ]; then
    $GIT clone $PKGGIT $PKGNAME
fi

echo "Prefix folder: " $APKG_PREFIX

# Pull the latest version
cd $APKG_PREFIX
$GIT pull
