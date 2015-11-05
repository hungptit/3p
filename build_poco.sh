#!/bin/bash

# Setup required variables
PROJECTS_FOLDER=$(pwd)
SRC_FOLDER=$PROJECTS_FOLDER/src
TMP_FOLDER=/tmp/build/

mkdir -p $TMP_FOLDER
mkdir -p $SRC_FOLDER

NCPUS=$(grep -c ^processor /proc/cpuinfo)
BUILD_OPTS=-j$((NCPUS+1))

CMAKE_PREFIX=$PROJECTS_FOLDER/cmake
CMAKE=$CMAKE_PREFIX/bin/cmake
CLANG=$PROJECTS_FOLDER/llvm/bin/clang
CLANGPP=$PROJECTS_FOLDER/llvm/bin/clang++
CMAKE_RELEASE_BUILD="-DCMAKE_BUILD_TYPE:STRING=Release"
CMAKE_USE_CLANG="-DCMAKE_CXX_COMPILER=${CLANGPP} -DCMAKE_C_COMPILER=${CLANG}"

GIT_PREFIX=$PROJECTS_FOLDER/git
GIT=$GIT_PREFIX/bin/git

BOOST_PREFIX=$PROJECTS_FOLDER/boost

# Get Poco
POCO_FOLDER=$SRC_FOLDER/poco
POCO_PREFIX=$PROJECTS_FOLDER/poco
# POCO_BUILD_FOLDER=$POCO_FOLDER/build_cmake_bin
POCO_BUILD_FOLDER=$TMP_FOLDER/build_cmake_bin

cd $SRC_FOLDER
if [ ! -d $POCO_FOLDER ]; then
    $GIT clone https://github.com/pocoproject/poco
fi

cd $POCO_FOLDER
$GIT pull

rm -r $POCO_PREFIX           # Cleanup the old installation

# Now build POCO with the custom CMake
mkdir $POCO_BUILD_FOLDER
cd $POCO_BUILD_FOLDER
$CMAKE $POCO_FOLDER -DCMAKE_INSTALL_PREFIX=$POCO_PREFIX -DPOCO_STATIC=1 $CMAKE_RELEASE_BUILD $CMAKE_USE_CLANG
make $BUILD_OPTS
make install
rm -rf $POCO_BUILD_FOLDER       # Cleanup build folder.
