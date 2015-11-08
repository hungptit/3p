#!/bin/bash
EXTERNAL_FOLDER=$PWD
SRC_FOLDER=$EXTERNAL_FOLDER/src
TMP_FOLDER=/tmp/build/

mkdir -p $TMP_FOLDER
mkdir -p $SRC_FOLDER

NCPUS=$(grep -c ^processor /proc/cpuinfo)
BUILD_OPTS=-j$((NCPUS+1))

# Comment these lines to use the 
CLANG=$EXTERNAL_FOLDER/llvm/bin/clang
CLANGPP=$EXTERNAL_FOLDER/llvm/bin/clang++
if [ ! -f $CLANGPP ]; then
    # Fall back to gcc if we do not have clang installed.
    CLANG=clang
    CLANGPP=clang++
fi

CMAKE_PREFIX=$EXTERNAL_FOLDER/cmake
CMAKE=$CMAKE_PREFIX/bin/cmake
if [ ! -f $CMAKE ]; then
    CMAKE=cmake                 # Use system CMake
fi

# Specify build type and other related parameters.
CMAKE_RELEASE_BUILD="-DCMAKE_BUILD_TYPE:STRING=Release"
CMAKE_USE_CLANG="-DCMAKE_CXX_COMPILER=${CLANGPP} -DCMAKE_C_COMPILER=${CLANG}"

# Install clang
LLVM_FOLDER=$SRC_FOLDER/llvm
LLVM_SRC_FOLDER=$LLVM_FOLDER/build
LLVM_PROJECTS_FOLDER=$LLVM_FOLDER/projects
LLVM_TOOLS_FOLDER=$LLVM_FOLDER/tools
LLVM_CLANG_FOLDER=$LLVM_FOLDER/clang
LLVM_CLANG_TOOLS_FOLDER=$LLVM_CLANG_FOLDER/tools
LLVM_PREFIX=$EXTERNAL_FOLDER/llvm

# Get all required source code
cd $SRC_FOLDER
svn co http://llvm.org/svn/llvm-project/llvm/trunk llvm # Get LLVM source code

cd $LLVM_TOOLS_FOLDER
svn co http://llvm.org/svn/llvm-project/cfe/trunk clang # Get clang source code

mkdir -p $LLVM_CLANG_TOOLS_FOLDER
cd $LLVM_CLANG_TOOLS_FOLDER
svn co http://llvm.org/svn/llvm-project/clang-tools-extra/trunk extra # Get extra feature

# Check out libraries
cd $LLVM_PROJECTS_FOLDER
svn co http://llvm.org/svn/llvm-project/compiler-rt/trunk compiler-rt
svn co http://llvm.org/svn/llvm-project/libcxx/trunk libcxx
svn co http://llvm.org/svn/llvm-project/libcxxabi/trunk libcxxabi

rm -rf $LLVM_SRC_FOLDER
mkdir -p $LLVM_SRC_FOLDER
cd $LLVM_SRC_FOLDER
$CMAKE -DCMAKE_INSTALL_PREFIX:PATH=$LLVM_PREFIX -DCMAKE_BUILD_TYPE:STRING=Release -DBUILD_TESTING:BOOL=OFF $CMAKE_USE_CLANG $LLVM_FOLDER 
make $BUILD_OPTS
rm $LLVM_PREFIX
make $BUILD_OPTS install 
