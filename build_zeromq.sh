#!/bin/bash
setup() {
    EXTERNAL_FOLDER=$(pwd)
    SRC_FOLDER=$EXTERNAL_FOLDER/src
    TMP_FOLDER=/tmp/build/

    mkdir -p $TMP_FOLDER
    mkdir -p $SRC_FOLDER

    NCPUS=$(grep -c ^processor /proc/cpuinfo)
    BUILD_OPTS=-j$((NCPUS+1))

    CLANG=$EXTERNAL_FOLDER/llvm/bin/clang
    CLANGPP=$EXTERNAL_FOLDER/llvm/bin/clang++
}

get_source_code() {
    ROOT_DIR=$1
    PACKAGE_NAME=$2
    GIT_LINK=$3
    
    cd $ROOT_DIR
    echo $ROOT_DIR
    if [ ! -d $PACKAGE_NAME ]; then
        git clone $GIT_LINK $PACKAGE_NAME
    fi
    PKG_DIR=$ROOT_DIR/$PACKAGE_NAME
    cd $PKG_DIR
    git pull
}

# Get the source code
setup
get_source_code $SRC_FOLDER libsodium https://github.com/jedisct1/libsodium.git
get_source_code $SRC_FOLDER libzmq https://github.com/zeromq/libzmq.git
get_source_code $EXTERNAL_FOLDER cppzmq https://github.com/zeromq/cppzmq.git 

# Install libsodium
LIBSODIUM_GIT=https://github.com/jedisct1/libsodium.git
LIBSODIUM_SRC=$SRC_FOLDER/libsodium
LIBSODIUM_PREFIX=$EXTERNAL_FOLDER/libsodium 
cd $LIBSODIUM_SRC
git pull
./autogen.sh
./configure --prefix=$LIBSODIUM_PREFIX CC=$CLANG CXX=$CLANG++
make $BUILD_OPTS
make install

# Install ZeroMQ
ZEROMQ_SRC=$SRC_FOLDER/libzmq
ZEROMQ_PREFIX=$EXTERNAL_FOLDER/libzmq

cd $ZEROMQ_SRC
git pull
./autogen.sh
./configure --prefix=$ZEROMQ_PREFIX --with-libsodium=no CC=$CLANG CXX=$CLANG++
make $BUILD_OPTS
make install

