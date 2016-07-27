#!/bin/bash
# Setup build environment
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
echo $CMAKE
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

install_node() {
    # Node.js
    NODE_GIT=https://github.com/nodejs/node.git
    NODE_FOLDER=$SRC_FOLDER/node
    NODE_PREFIX=$EXTERNAL_FOLDER/node

    cd $EXTERNAL_FOLDER
    sh install_pkg.sh $EXTERNAL_FOLDER node $NODE_GIT $SRC_FOLDER
    
    cd $NODE_FOLDER
    ./configure --prefix=$NODE_PREFIX --dest-cpu=x64 --dest-os=linux CC=$CLANG CXX=$CLANGPP
    make $BUILD_OPTS
    make install 
}

install_atom() {
    ATOM_GIT=https://github.com/atom/atom
    ATOM_FOLDER=$SRC_FOLDER/atom
    ATOM_PREFIX=$EXTERNAL_FOLDER/atom

    cd $SRC_FOLDER
    if [ ! -d $ATOM_FOLDER ]; then
        git clone $ATOM_GIT
    fi
    cd $ATOM_FOLDER
    git pull

    # Build atom
    # Note: Need to install libgnome-keyring-dev before building atom.
    script/build
    script/grunt install --install-dir $ATOM_PREFIX
}

# install_node
install_atom


