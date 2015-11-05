#!/bin/bash

# Setup required variables
PROJECTS_FOLDER=$(pwd)
SRC_FOLDER=$PROJECTS_FOLDER/src
TMP_FOLDER=/tmp/build/

mkdir -p $TMP_FOLDER
mkdir -p $SRC_FOLDER

NCPUS=$(grep -c ^processor /proc/cpuinfo)
BUILD_OPTS=-j$((NCPUS+1))

CMAKE_PREFIX=$PROJECTS_FOLDER/cmake
CMAKE=$CMAKE_PREFIX/bin/cmake
CLANG=$PROJECTS_FOLDER/llvm/bin/clang
CLANGPP=$PROJECTS_FOLDER/llvm/bin/clang++
CMAKE_RELEASE_BUILD="-DCMAKE_BUILD_TYPE:STRING=Release"
CMAKE_USE_CLANG="-DCMAKE_CXX_COMPILER=${CLANGPP} -DCMAKE_C_COMPILER=${CLANG}"

GIT_PREFIX=$PROJECTS_FOLDER/git
GIT=$GIT_PREFIX/bin/git

BOOST_PREFIX=$PROJECTS_FOLDER/boost

# Rocksdb
ROCKSDB_GIT=https://github.com/facebook/rocksdb/
ROCKSDB_PREFIX=$PROJECTS_FOLDER/rocksdb

if [ ! -d $ROCKSDB_PREFIX ]; then
    cd $PROJECTS_FOLDER
    $GIT clone $ROCKSDB_GIT
fi

cd $ROCKSDB_PREFIX
git pull
# git checkout rocksdb-3.13
make DEBUG_LEVEL=0 $BUILD_OPTS static_lib CC=$CLANG CXX=$CLANGPP
