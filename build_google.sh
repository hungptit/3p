#!/bin/bash

setup() {
    EXTERNAL_FOLDER=$PWD
    SRC_FOLDER=$EXTERNAL_FOLDER/src
    TMP_FOLDER=/tmp/build/

    mkdir -p $TMP_FOLDER
    mkdir -p $SRC_FOLDER

    NCPUS=$(grep -c ^processor /proc/cpuinfo)
    BUILD_OPTS=-j$((NCPUS+1))

    # Setup CMake
    CMAKE_PREFIX=$EXTERNAL_FOLDER/cmake
    CMAKE=$CMAKE_PREFIX/bin/cmake
    if [ ! -f $CMAKE ]; then
        # Use system CMake if we could not find the customized CMake.
        CMAKE=cmake
    fi

    # Setup git
    GIT_PREFIX=$EXTERNAL_FOLDER/git
    GIT=$GIT_PREFIX/bin/git
    if [ ! -f $GIT ]; then
        # Use system CMake if we could not find the customized CMake.
        GIT=git
    fi
}


build_leveldb() {
    LEVELDB_GIT=https://github.com/google/leveldb
    LEVELDB_PREFIX=$EXTERNAL_FOLDER/leveldb

    if [ ! -d $LEVELDB_PREFIX ]; then
        cd $EXTERNAL_FOLDER
        $GIT clone $LEVELDB_GIT
    fi

    cd $LEVELDB_PREFIX
    make clean
    git pull
    make $BUILD_OPTS
    cd $EXTERNAL_FOLDER
}

# Setup build environment
setup 

# Build all required packages
cd $EXTERNAL_FOLDER
sh build_using_autogen.sh snappy https://github.com/google/snappy.git "" "" "" > /dev/null
build_leveldb
sh build_using_cmake.sh $EXTERNAL_FOLDER gtest https://github.com/google/googletest.git
sh build_using_cmake.sh $EXTERNAL_FOLDER benchmark https://github.com/google/benchmark.git  > /dev/null
