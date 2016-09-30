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

# Setup CMake
CMAKE_PREFIX=$EXTERNAL_FOLDER/cmake
CMAKE=$CMAKE_PREFIX/bin/cmake
if [ ! -f $CMAKE ]; then
    # Use system CMake if we could not find the customized CMake.
    CMAKE=cmake
fi
# CMAKE_RELEASE_BUILD="-DCMAKE_BUILD_TYPE:STRING=Release"
CMAKE_RELEASE_BUILD="-DCMAKE_BUILD_TYPE=Release"
CMAKE_USE_CLANG="-DCMAKE_CXX_COMPILER=${CLANGPP} -DCMAKE_C_COMPILER=${CLANG}"

# Setup git
GIT_PREFIX=$EXTERNAL_FOLDER/git
GIT=$GIT_PREFIX/bin/git
if [ ! -f $GIT ]; then
    # Use system CMake if we could not find the customized CMake.
    GIT=git
fi

build_celero() {
    PKGNAME="Celero"
    PKGGIT="https://github.com/DigitalInBlue/Celero.git"
    sh install_pkg.sh $EXTERNAL_FOLDER $PKGNAME $PKGGIT $EXTERNAL_FOLDER
    APKG_SRC=$EXTERNAL_FOLDER/$PKGNAME
    APKG_BUILD_FOLDER=$TMP_FOLDER/$PKGNAME
    APKG_PREFIX=$EXTERNAL_FOLDER/$PKGNAME

    # Build Celero
    rm -rf $APKG_BUILD_FOLDER
    mkdir -p $APKG_BUILD_FOLDER
    cd $APKG_BUILD_FOLDER
    $CMAKE $APKG_SRC -DCMAKE_INSTALL_PREFIX=$APKG_PREFIX $CMAKE_RELEASE_BUILD $CMAKE_USE_CLANG 
    make $BUILD_OPTS
    make install
    cd $EXTERNAL_FOLDER
    rm -rf $APKG_BUILD_FOLDER
}

echo "Install Celero"
build_celero;
