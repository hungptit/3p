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

install_libcuckoo() {
    PKG_NAME=libcuckoo
    PKG_SRC=$SRC_FOLDER/$PKG_NAME
    PKG_PREFIX=$EXTERNAL_FOLDER/$PKG_NAME
    sh install_pkg.sh $EXTERNAL_FOLDER $PKG_NAME https://github.com/efficient/libcuckoo.git $SRC_FOLDER
    cd $PKG_SRC
    autoreconf -fis
    ./configure --prefix=$PKG_PREFIX
    make -j3
    make install
}

install_junction() {
    PKG_NAME=junction
    PKG_SRC=$SRC_FOLDER/$PKG_NAME
    PKG_PREFIX=$EXTERNAL_FOLDER/$PKG_NAME
    sh install_pkg.sh $EXTERNAL_FOLDER $PKG_NAME https://github.com/preshing/junction.git $SRC_FOLDER
}

cd $EXTERNAL_FOLDER
# install_libcuckoo;

cd $EXTERNAL_FOLDER
sh build_using_cmake.sh $EXTERNAL_FOLDER turf https://github.com/preshing/turf.git

cd $EXTERNAL_FOLDER
CMAKE_OPTIONS=""
sh build_using_cmake.sh $EXTERNAL_FOLDER junction https://github.com/preshing/junction.git $CMAKE_OPTIONS

