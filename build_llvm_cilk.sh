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
}

get_source_code() {
    ROOT_DIR=$1
    PACKAGE_NAME=$2
    GIT_LINK=$3

    cd $ROOT_DIR
    if [ ! -d $PACKAGE_NAME ]; then
        git clone -b cilkplus $GIT_LINK $PACKAGE_NAME
    fi
    PKG_DIR=$ROOT_DIR/$PACKAGE_NAME
    cd $PKG_DIR

    echo $PKG_DIR
    
    git clean -df
    git checkout $LLVM_TAG
    git pull
}

# Setup all required variables
setup

LLVM_NAME="llvm-cilk"

LLVM_SRC=$SRC_FOLDER/$LLVM_NAME
LLVM_BUILD_FOLDER=$LLVM_SRC/build/
LLVM_PREFIX=$EXTERNAL_FOLDER/$LLVM_NAME

# LLVM_TAG="release_39"
# LLVM_TAG="master"
LLVM_TAG="cilkplus"

# Get LLVM source code
get_source_code $SRC_FOLDER $LLVM_NAME https://github.com/cilkplus/llvm $LLVM_TAG
mkdir -p $LLVM_SRC/tools
mkdir -p $LLVM_SRC/projects

# Get clang and runtime library
get_source_code $LLVM_SRC/tools clang https://github.com/cilkplus/clang $LLVM_TAG
get_source_code $LLVM_SRC/projects compiler-rt https://github.com/cilkplus/compiler-rt $LLVM_TAG


# Build LLVM
# rm -rf $LLVM_BUILD_FOLDER
mkdir -p $LLVM_BUILD_FOLDER
cd $LLVM_BUILD_FOLDER

echo $LLVM_BUILD_FOLDER

$CMAKE -G "Unix Makefiles" -DINTEL_SPECIFIC_CILKPLUS=1 -DCMAKE_INSTALL_PREFIX:PATH=$LLVM_PREFIX -DCMAKE_BUILD_TYPE:STRING=Release -DBUILD_TESTING:BOOL=OFF -DLLVM_TARGETS_TO_BUILD=X86 $CMAKE_USE_CLANG $LLVM_SRC 
# # $CMAKE -DCMAKE_INSTALL_PREFIX:PATH=$LLVM_PREFIX -DCMAKE_BUILD_TYPE:STRING=Release -DBUILD_TESTING:BOOL=OFF $LLVM_SRC 
make $BUILD_OPTS
rm -rf $LLVM_PREFIX
make $BUILD_OPTS install 
