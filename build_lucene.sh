#!/bin/bash
EXTERNAL_FOLDER=$PWD
BUILD_FOLDER=$EXTERNAL_FOLDER/src
TMP_FOLDER=/tmp/build/

mkdir -p $TMP_FOLDER
mkdir -p $BUILD_FOLDER

NCPUS=$(grep -c ^processor /proc/cpuinfo)
BUILD_OPTS=-j$((NCPUS+1))

CLANG=$EXTERNAL_FOLDER/llvm/bin/clang
CLANGPP=$EXTERNAL_FOLDER/llvm/bin/clang++

CMAKE_PREFIX=$EXTERNAL_FOLDER/cmake
CMAKE=$CMAKE_PREFIX/bin/cmake
CMAKE_RELEASE_BUILD="-DCMAKE_BUILD_TYPE:STRING=Release"
CMAKE_USE_CLANG="-DCMAKE_CXX_COMPILER=${CLANGPP} -DCMAKE_C_COMPILER=${CLANG}"
BOOST_PREFIX=$EXTERNAL_FOLDER/boost

# Install LucenePlusPlus
LucenePlusPlus_GIT=https://github.com/luceneplusplus/LucenePlusPlus.git
LucenePlusPlus_FOLDER=$BUILD_FOLDER/LucenePlusPlus
LucenePlusPlus_PREFIX=$EXTERNAL_FOLDER/LucenePlusPlus
LucenePlusPlus_BUILD_FOLDER=$LucenePlusPlus_FOLDER/build

cd $BUILD_FOLDER
if [ ! -d $LucenePlusPlus_FOLDER ]; then
    git clone $LucenePlusPlus_GIT
fi
cd $LucenePlusPlus_FOLDER
git fetch
git pull
rm -rf $LucenePlusPlus_PREFIX $LucenePlusPlus_BUILD_FOLDER
mkdir -p $LucenePlusPlus_BUILD_FOLDER
cd $LucenePlusPlus_BUILD_FOLDER
$CMAKE ../ -DCMAKE_INSTALL_PREFIX=$LucenePlusPlus_PREFIX -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_CXX_COMPILER=clang++ -DBoost_INCLUDE_DIR=$BOOST_PREFIX/include
# $CMAKE ../ -DCMAKE_INSTALL_PREFIX=$LucenePlusPlus_PREFIX -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_CXX_COMPILER=clang++ -DLUCENE_USE_STATIC_BOOST_LIBS=true
make $BUILD_OPTS
make install
