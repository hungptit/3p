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
LucenePlusPlus_SRC_FOLDER=$LucenePlusPlus_FOLDER/build

cd $SRC_FOLDER
if [ ! -d $LucenePlusPlus_FOLDER ]; then
    git clone $LucenePlusPlus_GIT
fi
cd $LucenePlusPlus_FOLDER
git fetch
git pull
rm -rf $LucenePlusPlus_PREFIX $LucenePlusPlus_SRC_FOLDER
mkdir -p $LucenePlusPlus_SRC_FOLDER
cd $LucenePlusPlus_SRC_FOLDER

# Un comment this to use customized boost libraries.
# $CMAKE ../ -DCMAKE_INSTALL_PREFIX=$LucenePlusPlus_PREFIX -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_CXX_COMPILER=clang++ -DBoost_INCLUDE_DIR=$BOOST_PREFIX/include

# Un comment this line if system boost is installed
$CMAKE ../ -DCMAKE_INSTALL_PREFIX=$LucenePlusPlus_PREFIX -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_CXX_COMPILER=clang++ -DLUCENE_USE_STATIC_BOOST_LIBS=true

make $BUILD_OPTS
make install
