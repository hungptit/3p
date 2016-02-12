#!/bin/bash
# Setup build environment
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

# Setup git
GIT_PREFIX=$EXTERNAL_FOLDER/git
GIT=$GIT_PREFIX/bin/git
if [ ! -f $GIT ]; then
    # Use system CMake if we could not find the customized CMake.
    GIT=git
fi

# # Build CMake
# CMAKE_SRC=$SRC_FOLDER/cmake
# CMAKE_BUILD_FOLDER=$CMAKE_SRC/build
# cd $SRC_FOLDER
# if [ ! -d $CMAKE_SRC ]; then
#     $GIT clone git://cmake.org/cmake.git
# fi

# # Pull the latest version
# cd $CMAKE_SRC
# git pull

# # Build CMake
# mkdir -p $CMAKE_BUILD_FOLDER
# cd $CMAKE_BUILD_FOLDER
# $GIT checkout v3.3.2
# ../configure --prefix=$CMAKE_PREFIX --no-qt-gui
# make $BUILD_OPTS 
# rm $CMAKE_PREFIX                # Cleanup previously installed CMake
# make install

# # Get mercurial
# cd $SRC_FOLDER
# MERCURIAL_VERSION=3.2.4
# MERCURIAL_FILE=mercurial-3.2.4.tar.gz
# MERCURIAL_PREFIX=$EXTERNAL_FOLDER/mercurial
# MERCURIAL=$MERCURIAL_PREFIX-$MERCURIAL_VERSION/hg

# cd $SRC_FOLDER
# if [ ! -f $MERCURIAL_FILE ]; then
#     wget http://mercurial.selenic.com/release/mercurial-3.2.4.tar.gz;
# fi

# tar -xf $SRC_FOLDER/$MERCURIAL_FILE -C $EXTERNAL_FOLDER
# cd $MERCURIAL_PREFIX-$MERCURIAL_VERSION
# make local $BUILD_OPTS

# # sqlitebrowser
# SQLITEBROWSER_GIT=https://github.com/sqlitebrowser/sqlitebrowser
# SQLITEBROWSER_FOLDER=$SRC_FOLDER/sqlitebrowser
# SQLITEBROWSER_PREFIX=$EXTERNAL_FOLDER/sqlitebrowser
# SQLITEBROWSER_BUILD_FOLDER=$TMP_FOLDER/sqlitebrowser

# cd $SRC_FOLDER
# if [ ! -d $SQLITEBROWSER_FOLDER ]; then
#     git clone $SQLITEBROWSER_GIT
# fi
# cd $SQLITEBROWSER_FOLDER
# git pull

# mkdir -p $SQLITEBROWSER_BUILD_FOLDER
# cd $SQLITEBROWSER_BUILD_FOLDER
# $CMAKE $SQLITEBROWSER_FOLDER -DCMAKE_INSTALL_PREFIX=$SQLITEBROWSER_PREFIX $CMAKE_RELEASE_BUILD $CMAKE_USE_CLANG 
# make $BUILD_OPTS
# rm -rf $SQLITEBROWSER_PREFIX
# make install
# rm -rf $SQLITEBROWSER_BUILD_FOLDER

# # Build git
# GIT_FOLDER=$SRC_FOLDER/git
# GIT_BUILD_FOLDER=$GIT_FOLDER/build
# cd $SRC_FOLDER
# if [ ! -d $GIT_FOLDER ]; then
#     git clone https://github.com/git/git.git # assume we have git installed in our machine.
# fi

# # Pull the latest version
# cd $GIT_FOLDER
# git pull
# make configure
# ./configure --prefix=$GIT_PREFIX
# make $BUILD_OPTS PROFILE=BUILD
# rm -f $GIT_PREFIX
# make profile-fast-install $BUILD_OPTS

# # Build global
# GLOBAL_LINK=http://tamacom.com/global/
# GLOBAL_FILE=global-6.5.2
# GLOBAL_SRC=$SRC_FOLDER/global
# GLOBAL_PREFIX=$EXTERNAL_FOLDER/global

# cd $SRC_FOLDER
# if [ ! -f $GLOBAL_FILE.tar.gz ]; then
#     wget $GLOBAL_LINK/$GLOBAL_FILE.tar.gz
# fi

# # Pull the latest version
# tar xf $GLOBAL_FILE.tar.gz
# cd $GLOBAL_FILE
# make configure
# ./configure --prefix=$GLOBAL_PREFIX CFLAGS="-O4"
# make $BUILD_OPTS
# rm -rf $GLOBAL_PREFIX
# make install

# Build lz4
LZ4_GIT=https://github.com/Cyan4973/lz4
LZ4_SRC=$SRC_FOLDER/lz4
LZ4_PREFIX=$EXTERNAL_FOLDER/lz4
LZ4_BUILD=$TMP_FOLDER/lz4

cd $SRC_FOLDER
if [ ! -d $LZ4_SRC ]; then
    git clone $LZ4_GIT
fi
cd $LZ4_SRC
git pull
make $BUILD_OPTS
rm -rf $LZ4_PREFIX
make PREFIX=$LZ4_PREFIX install 
