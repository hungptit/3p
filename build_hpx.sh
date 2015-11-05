#!/bin/bash
EXTERNAL_FOLDER=$PWD
SRC_FOLDER=$EXTERNAL_FOLDER/src
BUILD_FOLDER=/tmp/build/

mkdir -p $BUILD_FOLDER
mkdir -p $SRC_FOLDER

NCPUS=$(grep -c ^processor /proc/cpuinfo)
BUILD_OPTS=-j$((NCPUS+1))

CLANG=$EXTERNAL_FOLDER/llvm/bin/clang
CLANGPP=$EXTERNAL_FOLDER/llvm/bin/clang++

CMAKE_PREFIX=$EXTERNAL_FOLDER/cmake
CMAKE=$CMAKE_PREFIX/bin/cmake
CMAKE_RELEASE_BUILD="-DCMAKE_BUILD_TYPE:STRING=Release"
CMAKE_USE_CLANG="-DCMAKE_CXX_COMPILER=${CLANGPP} -DCMAKE_C_COMPILER=${CLANG}"
BOOST_PREFIX=$EXTERNAL_FOLDER/boost

# Get gperftools
GPERFTOOLS_FOLDER=$SRC_FOLDER/gperftools
GPERFTOOLS_LINK=https://github.com/couchbase/gperftools
GPERFTOOLS_PREFIX=$EXTERNAL_FOLDER/gperftools

cd $SRC_FOLDER
if [ ! -d $GPERFTOOLS_FOLDER ]; then
    git clone $GPERFTOOLS_LINK
fi
cd $GPERFTOOLS_FOLDER
git pull

cd $GPERFTOOLS_FOLDER
sh autogen.sh
./configure --prefix=$GPERFTOOLS_PREFIX --enable-minimal
make $BUILD_OPTS install

# Install hwlock
HWLOCK_FOLDER=$SRC_FOLDER/hwloc
HWLOCK_LINK=https://github.com/open-mpi/hwloc
HWLOCK_PREFIX=$EXTERNAL_FOLDER/hwloc

cd $SRC_FOLDER
if [ ! -d $HWLOCK_FOLDER ]; then
    git clone $HWLOCK_LINK
fi
cd $HWLOCK_FOLDER
git pull
sh autogen.sh
./configure --prefix=$HWLOCK_PREFIX
make $BUILD_OPTS install

# Get HPX
HPX_FOLDER=$SRC_FOLDER/hpx
HPX_LINK=https://github.com/STEllAR-GROUP/hpx.git
HPX_PREFIX=$EXTERNAL_FOLDER/hpx
HPX_BUILD=$BUILD_FOLDER/build_hpx

cd $SRC_FOLDER
if [ ! -d $HPX_FOLDER ]; then
    git clone $HPX_LINK
fi
cd $HPX_FOLDER
git pull

# Need to build HPX using clang
rm -rf $HPX_BUILD
mkdir -p $HPX_BUILD
cd $HPX_BUILD
echo $PWD
$CMAKE $HPX_FOLDER -DCMAKE_INSTALL_PREFIX:PATH=$HPX_PREFIX -DBOOST_ROOT=$BOOST_PREFIX -DTCMALLOC_INCLUDE_DIR=$GPERFTOOLS_PREFIX/include -DTCMALLOC_LIBRARY=$GPERFTOOLS_PREFIX/lib -DHWLOC_ROOT=$HWLOCK_PREFIX -DCMAKE_BUILD_TYPE:STRING=Release $CMAKE_USE_CLANG
make $BUILD_OPTS
make install
