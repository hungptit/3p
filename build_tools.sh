#!/bin/bash
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

# Build git
GIT_FOLDER=$SRC_FOLDER/git
GIT_BUILD_FOLDER=$GIT_FOLDER/build
cd $SRC_FOLDER
if [ ! -d $GIT_FOLDER ]; then
    git clone https://github.com/git/git.git # assume we have git installed in our machine.
fi

# Pull the latest version
cd $GIT_FOLDER
git pull
make configure
./configure --prefix=$GIT_PREFIX
make $BUILD_OPTS PROFILE=BUILD
rm -f $GIT_PREFIX
make profile-fast-install $BUILD_OPTS

# Build CMake
CMAKE_PREFIX=$PROJECTS_FOLDER/cmake
CMAKE_SRC=$SRC_FOLDER/cmake
CMAKE_BUILD_FOLDER=$CMAKE_SRC/build
CMAKE=$CMAKE_PREFIX/bin/cmake
cd $SRC_FOLDER
if [ ! -d $CMAKE_SRC ]; then
    $GIT clone git://cmake.org/cmake.git
fi

# Pull the latest version
cd $CMAKE_SRC
git pull

# Build CMake
mkdir -p $CMAKE_BUILD_FOLDER
cd $CMAKE_BUILD_FOLDER
../configure --prefix=$CMAKE_PREFIX --no-qt-gui
make $BUILD_OPTS 
rm $CMAKE_PREFIX                # Cleanup previously installed CMake
make install

# Get mercurial
cd $SRC_FOLDER
MERCURIAL_VERSION=3.2.4
MERCURIAL_FILE=mercurial-3.2.4.tar.gz
MERCURIAL_PREFIX=$PROJECTS_FOLDER/mercurial
MERCURIAL=$MERCURIAL_PREFIX-$MERCURIAL_VERSION/hg

cd $SRC_FOLDER
if [ ! -f $MERCURIAL_FILE ]; then
    wget http://mercurial.selenic.com/release/mercurial-3.2.4.tar.gz;
fi

tar -xf $SRC_FOLDER/$MERCURIAL_FILE -C $PROJECTS_FOLDER
cd $MERCURIAL_PREFIX-$MERCURIAL_VERSION
make local $BUILD_OPTS

# sqlitebrowser
SQLITEBROWSER_GIT=https://github.com/sqlitebrowser/sqlitebrowser
SQLITEBROWSER_FOLDER=$SRC_FOLDER/sqlitebrowser
SQLITEBROWSER_PREFIX=$PROJECTS_FOLDER/sqlitebrowser
SQLITEBROWSER_BUILD_FOLDER=$TMP_FOLDER/sqlitebrowser

cd $SRC_FOLDER
if [ ! -d $SQLITEBROWSER_FOLDER ]; then
    git clone $SQLITEBROWSER_GIT
fi
cd $SQLITEBROWSER_FOLDER
git pull

mkdir -p $SQLITEBROWSER_BUILD_FOLDER
cd $SQLITEBROWSER_BUILD_FOLDER
$CMAKE ../ -DCMAKE_INSTALL_PREFIX=$SQLITEBROWSER_PREFIX $CMAKE_RELEASE_BUILD $CMAKE_USE_CLANG 
make $BUILD_OPTS
rm -rf $SQLITEBROWSER_PREFIX
make install
rm -rf $SQLITEBROWSER_BUILD_FOLDER
