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
CMAKE_RELEASE_BUILD="-DCMAKE_BUILD_TYPE:STRING=Release"
CMAKE_USE_CLANG="-DCMAKE_CXX_COMPILER=${CLANGPP} -DCMAKE_C_COMPILER=${CLANG}"

# Setup git
GIT_PREFIX=$EXTERNAL_FOLDER/git
GIT=$GIT_PREFIX/bin/git
if [ ! -f $GIT ]; then
    # Use system CMake if we could not find the customized CMake.
    GIT=git
fi

# Build boost from git source
BOOST_GIT=https://github.com/boostorg/boost.git
BOOST_SRC=$SRC_FOLDER/boost
BOOST_PREFIX=$EXTERNAL_FOLDER/boost
cd $SRC_FOLDER
if [ ! -d $BOOST_SRC ]; then
    git clone --recursive $BOOST_GIT
    cd $BOOST_SRC
fi
cd $BOOST_SRC
rm -rf $BOOST_PREFIX

# Update all modules
git fetch
git pull
git submodule update --recursive

./bootstrap.sh --prefix=$BOOST_PREFIX --without-icu
./b2 clean
./b2 headers
./b2 --build-dir=$TMPDIR/boost toolset=clang stage
./b2 $BUILD_OPTS --disable-icu --ignore-site-config variant=release threading=multi install
