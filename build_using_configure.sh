#!/bin/bash
EXTERNAL_FOLDER=$PWD
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
PKGNAME=$1
PKGGIT=$2
EXTRA_CONFIG_OPTIONS=$3
EXTRA_MAKE_OPTIONS=$4

APKG_SRC=$SRC_FOLDER/$PKGNAME
APKG_BUILD_FOLDER=$TMP_FOLDER/$PKGNAME
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
rm -rf $APKG_BUILD_FOLDER
mkdir $APKG_BUILD_FOLDER
cd $APKG_BUILD_FOLDER
$APKG_SRC/configure --prefix=$APKG_PREFIX $EXTRA_CONFIG_OPTIONS
make $BUILD_OPTS $EXTRA_MAKE_OPTIONS
rm -rf $APKG_PREFIX
make install
rm -rf $APKG_BUILD_FOLDER
