#!/bin/bash
EXTERNAL_FOLDER=$PWD
SRC_FOLDER=$EXTERNAL_FOLDER/src
TMP_FOLDER=/tmp/build/

mkdir -p $TMP_FOLDER
mkdir -p $SRC_FOLDER

NCPUS=$(grep -c ^processor /proc/cpuinfo)
BUILD_OPTS=-j$((NCPUS+1))

# Comment these lines to use the 
CC=$EXTERNAL_FOLDER/llvm/bin/clang
CXX=$EXTERNAL_FOLDER/llvm/bin/clang++
if [ ! -f $CXX ]; then
    # Fall back to gcc if we do not have clang installed.
    CC=gcc
    CXX=g++
fi

CMAKE_PREFIX=$EXTERNAL_FOLDER/cmake
CMAKE=$CMAKE_PREFIX/bin/cmake
if [ ! -f $CMAKE ]; then
    CMAKE=cmake                 # Use system CMake
fi

# Specify build type and other related parameters.
CMAKE_RELEASE_BUILD="-DCMAKE_BUILD_TYPE:STRING=Release"
CMAKE_USE_CLANG="-DCMAKE_CXX_COMPILER=${CXX} -DCMAKE_C_COMPILER=${CC}"

# Install clang
LLVM_FOLDER=$SRC_FOLDER/llvm
LLVM_BUILD_FOLDER=$LLVM_FOLDER/build
LLVM_PROJECTS_FOLDER=$LLVM_FOLDER/projects
LLVM_TOOLS_FOLDER=$LLVM_FOLDER/tools
LLVM_CLANG_FOLDER=$LLVM_FOLDER/clang
LLVM_CLANG_TOOLS_FOLDER=$LLVM_CLANG_FOLDER/tools
LLVM_PREFIX=$EXTERNAL_FOLDER/llvm

get_source_code() {
    ROOT_DIR=$1
    PACKAGE_NAME=$2
    GIT_LINK=$3
    
    cd $ROOT_DIR
    if [ ! -d $PACKAGE_NAME ]; then
        git clone $GIT_LINK
    fi
    cd $ROOT_DIR/$PACKAGE_NAME
    git pull
}

# Get all required source code
LLVM_SRC=$SRC_FOLDER/llvm
get_source_code $SRC_FOLDER llvm http://llvm.org/git/llvm.git

mkdir -p $LLVM_SRC/llvm/tools
get_source_code $LLVM_SRC/tools clang http://llvm.org/git/clang.git

mkdir $LLVM_SRC/llvm/projects
get_source_code $LLVM_SRC/projects compiler-rt http://llvm.org/git/compiler-rt.git
get_source_code $LLVM_SRC/projects openmp http://llvm.org/git/openmp.git
get_source_code $LLVM_SRC/projects libcxx http://llvm.org/git/libcxx.git
get_source_code $LLVM_SRC/projects libcxxabi http://llvm.org/git/libcxxabi.git
get_source_code $LLVM_SRC/projects test-suite http://llvm.org/git/test-suite.git

# Build LLVM
# rm -rf $LLVM_BUILD_FOLDER
# mkdir -p $LLVM_BUILD_FOLDER
# cd $LLVM_BUILD_FOLDER
# # $CMAKE -DCMAKE_INSTALL_PREFIX:PATH=$LLVM_PREFIX -DCMAKE_BUILD_TYPE:STRING=Release -DBUILD_TESTING:BOOL=OFF $CMAKE_USE_CLANG $LLVM_FOLDER 
# $CMAKE -DCMAKE_INSTALL_PREFIX:PATH=$LLVM_PREFIX -DCMAKE_BUILD_TYPE:STRING=Release -DBUILD_TESTING:BOOL=OFF $LLVM_FOLDER 
# make $BUILD_OPTS
# rm $LLVM_PREFIX
# make $BUILD_OPTS install 
