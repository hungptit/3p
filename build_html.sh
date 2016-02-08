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

# HTML tidy
TIDYHTML5_LINK=https://github.com/htacg/tidy-html5.git
TIDYHTML5_SRC=$SRC_FOLDER/tidy-html5
TIDYHTML5_PREFIX=$EXTERNAL_FOLDER/tidy-html5
TIDYHTML5_BUILD=$TMP_FOLDER/tidy-html5

cd $SRC_FOLDER
if [ ! -d $TIDYHTML5_SRC ]; then
    $GIT clone $TIDYHTML5_LINK
fi
cd $TIDYHTML5_SRC
$GIT pull

# Build tidy-html5
mkdir -p $TIDYHTML5_BUILD
cd $TIDYHTML5_BUILD
$CMAKE $TIDYHTML5_SRC -DCMAKE_INSTALL_PREFIX=$TIDYHTML5_PREFIX $CMAKE_RELEASE_BUILD $CMAKE_USE_CLANG
make $BUILD_OPTS
rm -rf $TIDYHTML5_PREFIX
make install


