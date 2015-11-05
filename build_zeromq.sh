#!/bin/bash
# Setup required variables
EXTERNAL_FOLDER=$(pwd)
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

# Install libsodium
LIBSODIUM_GIT=https://github.com/jedisct1/libsodium.git
LIBSODIUM_SRC=$SRC_FOLDER/libsodium
LIBSODIUM_PREFIX=$EXTERNAL_FOLDER/libsodium

if [ ! -d $LIBSODIUM_SRC ]; then
    cd $SRC_FOLDER
    git clone $LIBSODIUM_GIT
fi
cd $LIBSODIUM_SRC
git pull
./autogen.sh
./configure --prefix=$LIBSODIUM_PREFIX
make $BUILD_OPTS
make install

# ZeroMQ
ZEROMQ_GIT=https://github.com/zeromq/libzmq
ZEROMQ_SRC=$SRC_FOLDER/libzmq
ZEROMQ_PREFIX=$EXTERNAL_FOLDER/libzmq

if [ ! -d $ZEROMQ_SRC ]; then
    cd $SRC_FOLDER
    git clone $ZEROMQ_GIT
fi
cd $ZEROMQ_SRC
git pull
./autogen.sh
./configure --prefix=$ZEROMQ_PREFIX --with-libsodium=no CC=clang CXX=clang++
make $BUILD_OPTS
make install

# ZeroMQPP
CPPZMQ_GIT=https://github.com/zeromq/cppzmq.git
CPPZMQ_PREFIX=$EXTERNAL_FOLDER/cppzmq
if [ ! -d $CPPZMQ_PREFIX ]; then
    cd $EXTERNAL_FOLDER
    git clone $CPPZMQ_GIT
fi
cd $CPPZMQ_PREFIX
git pull
