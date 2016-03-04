#!/bin/bash
EXTERNAL_FOLDER=$PWD
SRC_FOLDER=$EXTERNAL_FOLDER/src
TMP_FOLDER=/tmp/build/

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
CMAKE_RELEASE_BUILD="-DCMAKE_BUILD_TYPE:STRING=Release"
CMAKE_USE_CLANG="-DCMAKE_CXX_COMPILER=${CLANGPP} -DCMAKE_C_COMPILER=${CLANG}"

# Setup git
GIT_PREFIX=$EXTERNAL_FOLDER/git
GIT=$GIT_PREFIX/bin/git
if [ ! -f $GIT ]; then
    # Use system CMake if we could not find the customized CMake.
    GIT=git
fi

mkdir -p $SRC_FOLDER
mkdir -p $TMP_FOLDER

EMACS_PREFIX=$EXTERNAL_FOLDER/emacs
mkdir -p $EMACS_PREFIX

# Setup RTags
RTAGS_GIT=https://github.com/Andersbakken/rtags.git
RTAGS_SRC=$SRC_FOLDER/rtags
RTAGS_BUILD=$TMP_FOLDER/rtags

if [ ! -d $RTAGS_SRC ]; then
    cd $SRC_FOLDER
    $GIT clone --recursive $RTAGS_GIT
    cd $RTAGS_SRC
    git submodule init
    git submodule update
fi

git pull

rm -rf $RTAGS_BUILD
mkdir -p $RTAGS_BUILD
cd $RTAGS_BUILD
$CMAKE $RTAGS_SRC -DCMAKE_EXPORT_COMPILE_COMMANDS=1 $CMAKE_RELEASE_BUILD
make $BUILD_OPTS
