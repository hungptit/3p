#!/bin/bash
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
CMAKE_RELEASE_BUILD="-DCMAKE_BUILD_TYPE:STRING=Release"
CMAKE_USE_CLANG="-DCMAKE_CXX_COMPILER=${CLANGPP} -DCMAKE_C_COMPILER=${CLANG}"

# Setup git
GIT_PREFIX=$EXTERNAL_FOLDER/git
GIT=$GIT_PREFIX/bin/git
if [ ! -f $GIT ]; then
    # Use system CMake if we could not find the customized CMake.
    GIT=git
fi

BOOST_PREFIX=$EXTERNAL_FOLDER/boost

# Install LucenePlusPlus
LucenePlusPlus_GIT=https://github.com/luceneplusplus/LucenePlusPlus.git
LucenePlusPlus_FOLDER=$SRC_FOLDER/LucenePlusPlus
LucenePlusPlus_PREFIX=$EXTERNAL_FOLDER/LucenePlusPlus
LucenePlusPlus_BUILD=$TMP_FOLDER/lucene

cd $SRC_FOLDER
if [ ! -d $LucenePlusPlus_FOLDER ]; then
    git clone $LucenePlusPlus_GIT
fi
cd $LucenePlusPlus_FOLDER
$GIT fetch
$GIT pull
rm -rf $LucenePlusPlus_BUILD
mkdir -p $LucenePlusPlus_BUILD
cd $LucenePlusPlus_BUILD

# Un comment this to use customized boost libraries.
# $CMAKE $LucenePlusPlus_FOLDER -DCMAKE_INSTALL_PREFIX=$LucenePlusPlus_PREFIX $CMAKE_RELEASE_BUILD -DBOOST_ROOT=$BOOST_PREFIX -DBoost_INCLUDE_DIR=$BOOST_PREFIX/include -DBoost_LIBRARY_DIR=$BOOST_PREFIX/lib -DLUCENE_USE_STATIC_BOOST_LIBS=true

# Un comment this line if system boost is installed
$CMAKE $LucenePlusPlus_FOLDER -DCMAKE_INSTALL_PREFIX=$LucenePlusPlus_PREFIX $CMAKE_RELEASE_BUILD $CMAKE_USE_CLANG -DLUCENE_USE_STATIC_BOOST_LIBS=true

make $BUILD_OPTS
rm -rf $LucenePlusPlus_PREFIX
make install
rm -rf $LucenePlusPlus_BUILD

# TODO: Try this approach
# export CMAKE_INCLUDE_PATH=/path/to/mkl/include
# export CMAKE_LIBRARY_PATH=/path/to/mkl/lib/intel64:/path/to/mkl/compiler/lib/intel64
# export LD_LIBRARY_PATH=$CMAKE_LIBRARY_PATH:$LD_LIBRARY_PATH
