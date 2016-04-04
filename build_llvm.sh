#!/bin/bash

# Setup build environment
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
    CMAKE_RELEASE_BUILD="-DCMAKE_BUILD_TYPE:STRING=Release"
    CMAKE_USE_CLANG="-DCMAKE_CXX_COMPILER=${CLANGPP} -DCMAKE_C_COMPILER=${CLANG}"

    # Setup CMake
    CMAKE_PREFIX=$EXTERNAL_FOLDER/cmake
    CMAKE=$CMAKE_PREFIX/bin/cmake
    if [ ! -f $CMAKE ]; then
        # Use system CMake if we could not find the customized CMake.
        CMAKE=cmake
    fi
    # CMAKE_RELEASE_BUILD="-DCMAKE_BUILD_TYPE:STRING=Release"
    CMAKE_RELEASE_BUILD="-DCMAKE_BUILD_TYPE=Release"
    CMAKE_USE_CLANG="-DCMAKE_CXX_COMPILER=${CLANGPP} -DCMAKE_C_COMPILER=${CLANG}"

    # Setup git
    GIT_PREFIX=$EXTERNAL_FOLDER/git
    GIT=$GIT_PREFIX/bin/git
    if [ ! -f $GIT ]; then
        # Use system CMake if we could not find the customized CMake.
        GIT=git
    fi

}

download_pkg() {
    ROOT_FOLDER=$1
    PKG_NAME=$2
    PKG_LINK=$3
    mkdir -p $ROOT_FOLDER
    cd $ROOT_FOLDER
    if [ ! -d $PKG_NAME ]; then
        $GIT clone $PKG_LINK
    fi
    cd $ROOT_FOLDER/$PKG_NAME
    git pull
}

setup
# Install clang
LLVM_FOLDER=$SRC_FOLDER/llvm
LLVM_BUILD_FOLDER=$LLVM_FOLDER/build
download_pkg $SRC_FOLDER llvm 

LLVM_PROJECTS_FOLDER=$LLVM_FOLDER/projects
LLVM_TOOLS_FOLDER=$LLVM_FOLDER/tools
LLVM_CLANG_FOLDER=$LLVM_FOLDER/clang
LLVM_CLANG_TOOLS_FOLDER=$LLVM_CLANG_FOLDER/tools
LLVM_PREFIX=$EXTERNAL_FOLDER/llvm

# Get all required source code
cd $SRC_FOLDER
if [ ! -d $LLVM_FOLDER ]; then
    git clone http://llvm.org/git/llvm.git
fi

cd $LLVM_FOLDER
git pull

mkdir -p $LLVM_CLANG_TOOLS_FOLDER
cd $LLVM_CLANG_TOOLS_FOLDER
git clone http://llvm.org/git/clang.git

# Check out clang-check and clang-tidy
LLVM_TOOLS_CLANG_TOOLS=$LLVM_FOLDER/tools/clang/tools
mkdir -p LLVM_TOOLS_CLANG_TOOLS
$GIT clone http://llvm.org/git/clang-tools-extra.git extra

# Check out libraries
cd $LLVM_PROJECTS_FOLDER
git clone http://llvm.org/git/openmp.git
git clone http://llvm.org/git/compiler-rt.git
git clone http://llvm.org/git/libcxx.git
git clone http://llvm.org/git/libcxxabi.git
# git clone http://llvm.org/git/test-suite.git

rm -rf $LLVM_BUILD_FOLDER
mkdir -p $LLVM_BUILD_FOLDER
cd $LLVM_BUILD_FOLDER
# $CMAKE -DCMAKE_INSTALL_PREFIX:PATH=$LLVM_PREFIX -DCMAKE_BUILD_TYPE:STRING=Release -DBUILD_TESTING:BOOL=OFF $CMAKE_USE_CLANG $LLVM_FOLDER 
$CMAKE -DCMAKE_INSTALL_PREFIX:PATH=$LLVM_PREFIX -DCMAKE_BUILD_TYPE:STRING=Release -DBUILD_TESTING:BOOL=OFF $LLVM_FOLDER 
# make $BUILD_OPTS
# rm $LLVM_PREFIX
# make $BUILD_OPTS install 
