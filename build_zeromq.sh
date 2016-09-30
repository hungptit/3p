#!/bin/bash
setup() {
    EXTERNAL_FOLDER=$(pwd)
    SRC_FOLDER=$EXTERNAL_FOLDER/src

    NCPUS=$(grep -c ^processor /proc/cpuinfo)
    BUILD_OPTS=-j$((NCPUS+1))
}

# Get the source code
setup
sh install_pkg.sh $EXTERNAL_FOLDER zguide https://github.com/booksbyus/zguide.git $EXTERNAL_FOLDER
sh install_pkg.sh $EXTERNAL_FOLDER cppzmq https://github.com/zeromq/cppzmq.git $EXTERNAL_FOLDER

# Install libsodium
# sh build_using_configure_notmpdir.sh $EXTERNAL_FOLDER libsodium https://github.com/jedisct1/libsodium.git "" ""

# Install ZeroMQ
sh build_using_configure_notmpdir.sh $EXTERNAL_FOLDER libzmq https://github.com/zeromq/libzmq.git "--with-libsodium=no" ""

# Install zguide
ZGUIDE_PREFIX=$EXTERNAL_FOLDER/zguide
cd $ZGUIDE_PREFIX
./bin/buildpdfs
