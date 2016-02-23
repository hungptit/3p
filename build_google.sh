#!/bin/bash

setup() {
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

    # Setup git
    GIT_PREFIX=$EXTERNAL_FOLDER/git
    GIT=$GIT_PREFIX/bin/git
    if [ ! -f $GIT ]; then
        # Use system CMake if we could not find the customized CMake.
        GIT=git
    fi
}

build_pkg() {
    PKG=$1
    PKG_LINK=$2    
    PKG_PREFIX=$EXTERNAL_FOLDER/$PKG
    PKG_SRC=$SRC_FOLDER/$PKG
    PKG_BUILD=$TMP_FOLDER/$PKG

    if [ ! -d $PKG_SRC ]; then
        cd $SRC_FOLDER
        $GIT clone $PKG_LINK
    fi

    cd $PKG_SRC
    $GIT pull
    sh autogen.sh
    echo $PWD
    ./configure --prefix=$PKG_PREFIX CXXFLAGS="$CXXFLAGS -O4 -Wall"
    make $BUILD_OPTS
    make install
}

build_cmake() {
    PKG=$1
    PKG_GIT=$2    
    PKG_SRC=$SRC_FOLDER/$PKG
    PKG_BUILD=$TMP_FOLDER/$PKG
    PKG_PREFIX=$EXTERNAL_FOLDER/$PKG

    echo $PKG_SRC
    echo $SRC_FOLDER
    if [ ! -d $PKG_SRC ]; then
        cd $SRC_FOLDER
        $GIT clone $PKG_GIT
        echo $PKG_GIT
    fi

    rm -rf $PKG_BUILD
    mkdir $PKG_BUILD
    cd $PKG_BUILD

    # Use gcc to make sure that we can build in old systems.
    $CMAKE -DCMAKE_INSTALL_PREFIX:PATH=$PKG_PREFIX $CMAKE_RELEASE_BUILD $PKG_SRC
    make $BUILD_OPTS
    rm -rf $PKG_BUILD
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
    make CXX=$CLANGPP $BUILD_OPTS
}

build_gtest() {
    GTEST_FOLDER=$SRC_FOLDER/gtest
    GTEST_SRC_FOLDER=$GTEST_FOLDER/build
    GTEST_PREFIX=$EXTERNAL_FOLDER/gtest

    cd $SRC_FOLDER
    if [ ! -d $GTEST_FOLDER ]; then
        svn checkout http://googletest.googlecode.com/svn/trunk/ gtest
    fi

    cd $GTEST_FOLDER
    svn update

    rm -rf $GTEST_SRC_FOLDER
    mkdir -p $GTEST_SRC_FOLDER
    cd $GTEST_SRC_FOLDER
    $CMAKE -DCMAKE_INSTALL_PREFIX:PATH=$GTEST_PREFIX $CMAKE_RELEASE_BUILD $GTEST_FOLDER
    make $BUILD_OPTS

    # We need to install gtest manually.
    rm -rf $GTEST_PREFIX
    mkdir -p $GTEST_PREFIX
    mkdir -p $GTEST_PREFIX/include
    mkdir -p $GTEST_PREFIX/lib
    cp -r $GTEST_FOLDER/include/gtest $GTEST_PREFIX/include
    cp lib*.a $GTEST_PREFIX/lib/
}

build_hashmap() {
    SPARSEHASH_LINK=http://sparsehash.googlecode.com/svn/trunk/
    SPARSEHASH_FOLDER=$SRC_FOLDER/sparsehash
    SPARSEHASH_PREFIX=$EXTERNAL_FOLDER/sparsehash

    cd $SRC_FOLDER
    if [ ! -d $SPARSEHASH_FOLDER ]; then
        svn checkout $SPARSEHASH_LINK sparsehash
    fi
    cd $SPARSEHASH_FOLDER
    svn update

    ./configure --prefix=$SPARSEHASH_PREFIX
    make $BUILD_OPTS
    make install
}

# Setup build environment
setup 

# Build all required packages
build_pkg snappy https://github.com/google/snappy.git
build_leveldb
build_gtest
build_hashmap
build_cmake benchmark https://github.com/google/benchmark.git
