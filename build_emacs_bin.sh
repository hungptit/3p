# ********************************
#  Build emacs related packages  *
# ********************************
#!/bin/bash

# Setup build environment
EXTERNAL_FOLDER=$PWD
SRC_FOLDER=$EXTERNAL_FOLDER/src
TMP_FOLDER=/tmp/build/

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

mkdir -p $SRC_FOLDER
mkdir -p $TMP_FOLDER

EMACS_PREFIX=$EXTERNAL_FOLDER/emacs
mkdir -p $EMACS_PREFIX

# Build Emacs
EMACS_SRC=$SRC_FOLDER/emacs
EMACS_LINK=git://git.savannah.gnu.org/emacs.git
EMACS_PREFIX=$EXTERNAL_FOLDER/emacs
cd $SRC_FOLDER
if [ ! -d $EMACS_SRC ]; then
    git clone $EMACS_LINK
fi

# Now enter emacs source folder and build
cd $EMACS_SRC
git checkout master
git pull
./configure --prefix=$EMACS_PREFIX --with-x
make $BUILD_OPTS
# make install

# Build silver searcher
SILVER_SEARCH_GIT=https://github.com/ggreer/the_silver_searcher.git
SILVER_SEARCH_FOLDER=$SRC_FOLDER/the_silver_searcher
SILVER_SEARCH_PREFIX=$EMACS_PREFIX/the_silver_searcher

# Prepare the source code
cd $SRC_FOLDER
if [ ! -d $SILVER_SEARCH_FOLDER ]; then
    git clone $SILVER_SEARCH_GIT
fi
cd $SILVER_SEARCH_FOLDER
git pull

# Now build and install the_silver_searcher
sh build.sh
./configure --prefix=$SILVER_SEARCH_PREFIX CC=$CLANG CFLAGS="-O4 -Wall"
make $BUILD_OPTS
make install

# Build cask
CASK_FOLDER=$EMACS_PREFIX/cask
CASK_GIT=https://github.com/cask/cask.git
cd $EMACS_PREFIX

if [ ! -d $CASK_FOLDER ]; then
    git clone $CASK_GIT cask
fi
cd $CASK_FOLDER
git pull

# ctags
CTAGS_LINK=https://github.com/universal-ctags/ctags.git
CTAGS_SRC=$SRC_FOLDER/ctags
CTAGS_PREFIX=$EXTERNAL_FOLDER/ctags
CTAGS_BUILD=$TMP_FOLDER/ctags
cd $SRC_FOLDER
if [ ! -d $CTAGS_SRC ]; then
    $GIT clone $CTAGS_LINK
fi
cd $CTAGS_SRC
git checkout master
git pull
./autogen.sh
./configure --prefix=$CTAGS_PREFIX EXTRA_CFLAGS="-O4 -Wall" EXTRA_CPPFLAGS="-O4"
make $BUILD_OPTS
rm -rf $CTAGS_PREFIX
make install

# Build global
GLOBAL_LINK=http://tamacom.com/global/
GLOBAL_FILE=global-6.5.2
GLOBAL_SRC=$SRC_FOLDER/global
GLOBAL_PREFIX=$EXTERNAL_FOLDER/global

cd $SRC_FOLDER
if [ ! -f $GLOBAL_FILE.tar.gz ]; then
    wget $GLOBAL_LINK/$GLOBAL_FILE.tar.gz
fi

# Pull the latest version
tar xf $GLOBAL_FILE.tar.gz
cd $GLOBAL_FILE
make configure
./configure --prefix=$GLOBAL_PREFIX CFLAGS="-O4 -Wall"
make $BUILD_OPTS
rm -rf $GLOBAL_PREFIX
make install
