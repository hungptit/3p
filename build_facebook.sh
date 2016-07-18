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

# CLANG=gcc
# CLANGPP=g++

# Setup CMake
CMAKE_PREFIX=$EXTERNAL_FOLDER/cmake
CMAKE=$CMAKE_PREFIX/bin/cmake
if [ ! -f $CMAKE ]; then
    CMAKE=cmake
fi
CMAKE_RELEASE_BUILD="-DCMAKE_BUILD_TYPE:STRING=Release"
CMAKE_USE_CLANG="-DCMAKE_CXX_COMPILER=${CLANGPP} -DCMAKE_C_COMPILER=${CLANG}"

# Setup git
GIT_PREFIX=$EXTERNAL_FOLDER/git
GIT=$GIT_PREFIX/bin/git
if [ ! -f $GIT ]; then
    GIT=git
fi

# Rocksdb
ROCKSDB_GIT=https://github.com/hungptit/rocksdb.git
ROCKSDB_PREFIX=$EXTERNAL_FOLDER/rocksdb
sh install_pkg.sh $EXTERNAL_FOLDER rocksdb https://github.com/hungptit/rocksdb.git $EXTERNAL_FOLDER
cd $ROCKSDB_PREFIX
$GIT pull
make clean
make DEBUG_LEVEL=0 $BUILD_OPTS static_lib EXTRA_CXXFLAGS="-O4" EXTRA_CFLAGS="-O4"

# HHVM
sh install_pkg.sh folly https://github.com/facebook/folly
sh install_pkg.sh hhvm https://github.com/facebook/hhvm.git
sh install_pkg.sh proxygen https://github.com/facebook/proxygen.git

# get jemalloc
JEMALLOC_PREFIX=$EXTERNAL_FOLDER/jemalloc
JEMALLOC_SRC=$SRC_FOLDER/jemalloc
JEMALLOC_BUILD=$SRC_FOLDER/jemalloc
sh install_pkg.sh $EXTERNAL_FOLDER jemalloc https://github.com/jemalloc/jemalloc.git $SRC_FOLDER

# Build jemalloc
sh autogen.sh
cd $JEMALLOC_BUILD
$JEMALLOC_SRC/configure --prefix=$JEMALLOC_PREFIX
make clean
make build_lib_static build_doc $BUILD_OPTS 
rm -rf $JEMALLOC_PREFIX
make install
