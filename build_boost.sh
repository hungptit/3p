#!/bin/bash
EXTERNAL_FOLDER=$PWD
SRC_FOLDER=$EXTERNAL_FOLDER/src
TMP_FOLDER=/tmp/build/

mkdir -p $TMP_FOLDER
mkdir -p $SRC_FOLDER

NCPUS=$(grep -c ^processor /proc/cpuinfo)
BUILD_OPTS=-j$((NCPUS+1))

CLANG=$EXTERNAL_FOLDER/llvm/bin/clang
CLANGPP=$EXTERNAL_FOLDER/llvm/bin/clang++

CMAKE_PREFIX=$EXTERNAL_FOLDER/cmake
CMAKE=$CMAKE_PREFIX/bin/cmake
CMAKE_RELEASE_BUILD="-DCMAKE_BUILD_TYPE:STRING=Release"
CMAKE_USE_CLANG="-DCMAKE_CXX_COMPILER=${CLANGPP} -DCMAKE_C_COMPILER=${CLANG}"
BOOST_PREFIX=$EXTERNAL_FOLDER/boost

# Build boost from git source
BOOST_GIT=https://github.com/boostorg/boost.git
BOOST_SRC=$SRC_FOLDER/boost
cd $SRC_FOLDER
if [ ! -d $BOOST_SRC ]; then
    git clone --recursive $BOOST_GIT
    cd $BOOST_SRC
fi
cd $BOOST_SRC
rm -rf $BOOST_PREFIX
git fetch
git pull
./bootstrap.sh --prefix=$BOOST_PREFIX
./b2 clean
./b2 headers
./b2 $BUILD_OPTS --ignore-site-config variant=release threading=multi install
