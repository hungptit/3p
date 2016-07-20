#!/bin/bash
EXTERNAL_FOLDER=$1
PKGNAME=$2
PKGGIT=$3
EXTRA_CONFIG_OPTIONS=$4
EXTRA_MAKE_OPTIONS=$5
SRC_FOLDER=$EXTERNAL_FOLDER/src
TMP_FOLDER=/tmp/build/

mkdir -p $TMP_FOLDER
mkdir -p $SRC_FOLDER

NCPUS=$(grep -c ^processor /proc/cpuinfo)
BUILD_OPTS=-j$((NCPUS+1))

# Setup clang
CLANG=$EXTERNAL_FOLDER/llvm/bin/clang
CLANGPP=$EXTERNAL_FOLDER/llvm/bin/clang++
if [ ! -f $CLANGPP ]; then
    # Fall back to gcc if we do not have clang installed.
    CLANG=gcc
    CLANGPP=g++
fi

# Setup git
GIT_PREFIX=$EXTERNAL_FOLDER/git
GIT=$GIT_PREFIX/bin/git
if [ ! -f $GIT ]; then
    GIT=git
fi

# Build given package
APKG_SRC=$SRC_FOLDER/$PKGNAME
APKG_BUILD_FOLDER=$APKG_SRC/build
APKG_PREFIX=$EXTERNAL_FOLDER/$PKGNAME

echo "Src folder: " $APKG_SRC
echo "Build folder: " $APKG_BUILD_FOLDER
echo "Prefix folder: " $APKG_PREFIX

cd $SRC_FOLDER
if [ ! -d $APKG_SRC ]; then
    $GIT clone $PKGGIT $PKGNAME
fi

# Pull the latest version
cd $APKG_SRC
$GIT pull

# Build a given package
cd $APKG_SRC
make clean
make $BUILD_OPTS $EXTRA_MAKE_OPTIONS
rm -rf $APKG_PREFIX
make PREFIX=$APKG_PREFIX install

# Return to the external folder.
cd $EXTERNAL_FOLDER 
