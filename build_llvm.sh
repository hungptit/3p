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

    # Setup git
    GIT_PREFIX=$EXTERNAL_FOLDER/git
    GIT=$GIT_PREFIX/bin/git
    if [ ! -f $GIT ]; then
        # Use system git if we could not find the customized git.
        GIT=git
    fi
    
    LLVM_FOLDER=$SRC_FOLDER/llvm
    LLVM_BUILD_FOLDER=$LLVM_FOLDER/build
    LLVM_PREFIX=$EXTERNAL_FOLDER/llvm
    LLVM_TAG="release_38"
}

get_source_code() {
    ROOT_DIR=$1
    PACKAGE_NAME=$2
    GIT_LINK=$3

    cd $ROOT_DIR
    if [ ! -d $PACKAGE_NAME ]; then
        git clone $GIT_LINK $PACKAGE_NAME
    fi
    PKG_DIR=$ROOT_DIR/$PACKAGE_NAME
    cd $PKG_DIR

    # Cannot go higher in Debian 7.4
    LLVM_TAG="release_38"       
            
    git clean -df
    git checkout $LLVM_TAG
    git pull
}

# Setup all required variables
setup

# Get LLVM source code
get_source_code $SRC_FOLDER llvm http://llvm.org/git/llvm.git

LLVM_SRC=$SRC_FOLDER/llvm
mkdir -p $LLVM_SRC/tools
mkdir -p $LLVM_SRC/projects

# Get clang and clang-extra-tools
get_source_code $LLVM_SRC/tools clang http://llvm.org/git/clang.git $LLVM_TAG
get_source_code $LLVM_SRC/tools/clang/tools extra http://llvm.org/git/clang-tools-extra.git $LLVM_TAG

# TODO: Cannot compile these packages in Debian 7.4 because of old STL libraries.
# Get other libraries
# get_source_code $LLVM_SRC/projects compiler-rt http://llvm.org/git/compiler-rt.git $LLVM_TAG
# get_source_code $LLVM_SRC/projects openmp http://llvm.org/git/openmp.git $LLVM_TAG
# get_source_code $LLVM_SRC/projects libcxx http://llvm.org/git/libcxx.git $LLVM_TAG
# get_source_code $LLVM_SRC/projects libcxxabi http://llvm.org/git/libcxxabi.git $LLVM_TAG
# get_source_code $LLVM_SRC/projects test-suite http://llvm.org/git/test-suite.git $LLVM_TAG

# Build LLVM
# rm -rf $LLVM_BUILD_FOLDER
mkdir -p $LLVM_BUILD_FOLDER
cd $LLVM_BUILD_FOLDER
# $CMAKE -DCMAKE_INSTALL_PREFIX:PATH=$LLVM_PREFIX -DCMAKE_BUILD_TYPE:STRING=Release -DBUILD_TESTING:BOOL=OFF $CMAKE_USE_CLANG $LLVM_FOLDER 
$CMAKE -DCMAKE_INSTALL_PREFIX:PATH=$LLVM_PREFIX -DCMAKE_BUILD_TYPE:STRING=Release -DBUILD_TESTING:BOOL=OFF $LLVM_FOLDER 
make $BUILD_OPTS
rm -rf $LLVM_PREFIX
make $BUILD_OPTS install 
