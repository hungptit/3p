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

# Get Poco
POCO_FOLDER=$SRC_FOLDER/poco
POCO_PREFIX=$EXTERNAL_FOLDER/poco
POCO_BUILD_FOLDER=$TMP_FOLDER/poco

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
