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
# CMAKE_RELEASE_BUILD="-DCMAKE_BUILD_TYPE:STRING=Release"
CMAKE_RELEASE_BUILD="-DCMAKE_BUILD_TYPE=Release"
CMAKE_USE_CLANG="-DCMAKE_CXX_COMPILER=${CLANGPP} -DCMAKE_C_COMPILER=${CLANG}"

# Setup git
GIT_PREFIX=$EXTERNAL_FOLDER/git
GIT=$GIT_PREFIX/bin/git
if [ ! -f $GIT ]; then
    # Use system CMake if we could not find the customized CMake.
    GIT=git
fi

# # Install doxygen
# DOXYGEN_SRC=$SRC_FOLDER/doxygen
# DOXYGEN_LINK=https://github.com/doxygen/doxygen.git
# DOXYGEN_PREFIX=$EXTERNAL_FOLDER/doxygen
# DOXYGEN_BUILD_FOLDER=$TMP_FOLDER/doxygen

# cd $SRC_FOLDER
# if [ ! -d $DOXYGEN_SRC ]; then
#     $GIT clone $DOXYGEN_LINK
# fi

# cd $DOXYGEN_SRC
# $GIT pull

# mkdir $DOXYGEN_BUILD_FOLDER
# cd $DOXYGEN_BUILD_FOLDER
# $CMAKE $DOXYGEN_SRC -DCMAKE_INSTALL_PREFIX=$DOXYGEN_PREFIX $CMAKE_RELEASE_BUILD $CMAKE_USE_CLANG
# make $BUILD_OPTS 
# rm -rf $DOXYGEN_PREFIX
# make install
# rm -rf $DOXYGEN_BUILD_FOLDER


# # Cereal
# CEREAL_GIT=https://github.com/USCiLab/cereal
# CEREAL_PREFIX=$EXTERNAL_FOLDER/cereal
# if [ ! -d $CEREAL_PREFIX ]; then
#     cd $EXTERNAL_FOLDER
#     $GIT clone $CEREAL_GIT
# fi

# cd $CEREAL_PREFIX
# $GIT pull

# # Rapidjson
# RAPIDJSON_GIT=https://github.com/miloyip/rapidjson
# RAPIDJSON_PREFIX=$EXTERNAL_FOLDER/rapidjson

# if [ ! -d $RAPIDJSON_PREFIX ]; then
#     cd $EXTERNAL_FOLDER
#     $GIT clone $RAPIDJSON_GIT
# fi

# cd $RAPIDJSON_PREFIX
# git pull

# # Install splog
# SPLOG_GIT=https://github.com/gabime/spdlog.git
# SPLOG_PREFIX=$EXTERNAL_FOLDER/spdlog
# cd $EXTERNAL_FOLDER
# if [ ! -d $SPLOG_PREFIX ]; then
#     $GIT clone $SPLOG_GIT
# fi
# cd $SPLOG_PREFIX
# $GIT fetch 
# $GIT pull

# # Get TBB
# TBB_LINK=https://www.threadingbuildingblocks.org/sites/default/files/software_releases/source/tbb43_20150316oss_src.tgz
# TBB_PREFIX=$EXTERNAL_FOLDER/tbb
# TBB_FILE=tbb43_20150316oss_src.tgz

# if [ ! -f $TBB_FILE ]; then
#     wget $TBB_LINK
# fi

# # Install TBB
# TBB_LINK=https://www.threadingbuildingblocks.org/sites/default/files/software_releases/linux/tbb43_20150316oss_lin.tgz
# TBB_PREFIX=$EXTERNAL_FOLDER/tbb
# TBB_FILE=tbb43_20150316oss_lin.tgz

# if [ ! -f $TBB_FILE ]; then
#     wget --no-check-certificate $TBB_LINK
# fi

# rm -rf $TBB_PREFIX
# tar xf $TBB_FILE
# mv tbb43_20150316oss $TBB_PREFIX

# # Get EIGEN
# EIGEN_SRC=$SRC_FOLDER/eigen
# EIGEN_BUILD_FOLDER=$TMP_FOLDER/eigen/
# EIGEN_PREFIX=$TMP_FOLDER/eigen

# MERCURIAL_VERSION=3.2.4
# MERCURIAL_PREFIX=$EXTERNAL_FOLDER/mercurial
# MERCURIAL=$MERCURIAL_PREFIX-$MERCURIAL_VERSION/hg

# cd $SRC_FOLDER
# if [ -d $EIGEN_SRC ];
# then
#     cd $EIGEN_SRC
#     $MERCURIAL pull
#     $MERCURIAL update
# else
#     cd $SRC_FOLDER
#     $MERCURIAL clone https://bitbucket.org/eigen/eigen/
#     cd $EIGEN_SRC
# fi
# rm -rf $EIGEN_BUILD_FOLDER
# mkdir $EIGEN_BUILD_FOLDER
# cd $EIGEN_BUILD_FOLDER
# $CMAKE $EIGEN_SRC -DCMAKE_INSTALL_PREFIX=$EIGEN_PREFIX $CMAKE_RELEASE_BUILD $CMAKE_USE_CLANG
# make install $BUILD_OPTS
# rm -rf $EIGEN_BUILD_FOLDER

# # CPPFormat
# CPPFORMAT_GIT=https://github.com/cppformat/cppformat.git
# CPPFORMAT_SRC=$SRC_FOLDER/cppformat
# CPPFORMAT_BUILD_FOLDER=$TMP_FOLDER/cppformat
# CPPFORMAT_PREFIX=$EXTERNAL_FOLDER/cppformat

# cd $SRC_FOLDER
# if [ ! -d $CPPFORMAT_SRC ]; then
#     $GIT clone $CPPFORMAT_GIT
# fi

# cd $CPPFORMAT_SRC
# git pull
# rm -rf $CPPFORMAT_BUILD_FOLDER
# mkdir -p $CPPFORMAT_BUILD_FOLDER
# cd $CPPFORMAT_BUILD_FOLDER
# $CMAKE $CPPFORMAT_SRC -DCMAKE_INSTALL_PREFIX=$CPPFORMAT_PREFIX $CMAKE_RELEASE_BUILD $CMAKE_USE_CLANG
# make $BUILD_OPTS
# rm -rf $CPPFORMAT_PREFIX
# make install
# rm -rf $CPPFORMAT_BUILD_FOLDER

# # Get libevent
# LIBEVENT_GIT=git://levent.git.sourceforge.net/gitroot/levent/libevent
# LIBEVENT_FOLDER=$SRC_FOLDER/libevent
# LIBEVENT_PREFIX=$EXTERNAL_FOLDER/libevent
# cd $SRC_FOLDER
# if [ ! -d $LIBEVENT_FOLDER ]; then
#     cd $SRC_FOLDER
#     git clone $LIBEVENT_GIT
# fi
# cd $LIBEVENT_FOLDER
# $GIT pull
# ./autogen.sh
# ./configure --prefix=$LIBEVENT_PREFIX
# make $BUILD_OPTS
# rm -rf $LIBEVENT_PREFIX
# make install

# # Get memcached
# MEMCACHED_GIT=git://github.com/memcached/memcached.git
# MEMCACHED_FOLDER=$SRC_FOLDER/memcached
# MEMCACHED_PREFIX=$EXTERNAL_FOLDER/memcached
# if [ ! -d $MEMCACHED_FOLDER ]; then
#     cd $SRC_FOLDER
#     git clone $MEMCACHED_GIT
# fi

# cd $MEMCACHED_FOLDER
# $GIT pull
# ./autogen.sh
# ./configure --prefix=$MEMCACHED_PREFIX --with-libevent=$LIBEVENT_PREFIX
# make $BUILD_OPTS
# rm -rf $MEMCACHED_PREFIX
# make install

# # Get libmemcached
# LIBMEMCACHED_LINK=https://launchpad.net/libmemcached/1.0/1.0.18/+download/libmemcached-1.0.18.tar.gz
# LIBMEMCACHED_FILE=libmemcached-1.0.18.tar.gz
# LIBMEMCACHED_FOLDER=$SRC_FOLDER/libmemcached-1.0.18
# LIBMEMCACHED_PREFIX=$EXTERNAL_FOLDER/libmemcached

# if [ ! -f $LIBMEMCACHED_FILE ]; then
#     cd $SRC_FOLDER
#     tar xf $LIBMEMCACHED_FILE
# fi

# cd $LIBMEMCACHED_FOLDER
# ./configure --prefix=$LIBMEMCACHED_PREFIX --with-memcached=$MEMCACHED_PREFIX
# make $BUILD_OPTS
# rm -rf $LIBMEMCACHED_PREFIX
# make install

# # Build zlib
# ZLIB_FILE=zlib-1.2.8
# ZLIB_GIT=https://github.com/madler/zlib.git
# ZLIB_SRC=$SRC_FOLDER/zlib
# ZLIB_PREFIX=$EXTERNAL_FOLDER/zlib

# if [ ! -d $ZLIB_SRC ]; then
#     cd $SRC_FOLDER
#     $GIT clone $ZLIB_GIT
# fi

# cd $ZLIB_SRC
# git pull
# ./configure --prefix=$ZLIB_PREFIX --static
# make $BUILD_OPTS
# rm -rf $ZLIB_PREFIX
# make install
# cd $SRC_FOLDER

# # Build HDF5
# # HDF5_FILE=hdf5-1.8.10
# # HDF5_GIT=https://gitorious.org/hdf5/hdf5-v18.git
# # HDF5_SRC=$SRC_FOLDER/hdf5-v18
# # HDF5_PREFIX=$EXTERNAL_FOLDER/hdf5

# # if [ ! -d $HDF5_SRC  ]; then
# #     git clone $HDF5_GIT
# # fi

# # # Check out the latest version
# # cd $HDF5_SRC
# # git pull;

# # # Now build and install the library
# # ./configure --prefix=$HDF5_PREFIX --with-zlib=$ZLIB_PREFIX --enable-hl --enable-production --enable-cxx --enable-static-exec --enable-shared=0
# # make $BUILD_OPTS
# # rm -rf $HDF5_PREFIX
# # make install

# # Build bzip2
# BZIP2_FILE=bzip2-1.0.6.tar.gz
# BZIP2_LINK=http://www.bzip.org/1.0.6/${BZIP2_FILE}
# BZIP2_SRC=$SRC_FOLDER/bzip2-1.0.6
# BZIP2_BUILD=$TMP_FOLDER/bzip2
# BZIP2_PREFIX=$EXTERNAL_FOLDER/bzip2

# cd $SRC_FOLDER
# if [ ! -f $BZIP2_FILE ]; then
#     wget $BZIP2_LINK
# fi

# if [ ! -d $BZIP2_SRC ]; then
#     tar xf $BZIP2_FILE
# fi

# cd $BZIP2_SRC
# make clean
# make $BUILD_OPTS CC=$CLANG CXX=$CLANGPP CFLAGS="-O4 -Wall" CXXFLAGS="-O4 -Wall" 
# rm -rf $BZIP2_PREFIX
# make install PREFIX=$BZIP2_PREFIX

# # Build zlib
# ZLIB_GIT=https://github.com/madler/zlib
# ZLIB_SRC=$SRC_FOLDER/zlib
# ZLIB_PREFIX=$EXTERNAL_FOLDER/zlib

# if [ ! -d $ZLIB_SRC ]; then
#     cd $SRC_FOLDER
#     git clone $ZLIB_GIT
# fi

# cd $ZLIB_SRC
# git pull
# make clean
# ./configure --prefix=$ZLIB_PREFIX CC=$CLANG CXX=$CLANGPP CFLAGS="-O4 -Wall" CXXFLAGS="-O4 -Wall" 
# make $BUILD_OPTS
# rm -rf $ZLIB_PREFIX
# make install 

# Casablanca
CPPRESTSDK_GIT=https://github.com/Microsoft/cpprestsdk.git
CPPRESTSDK_SRC=$SRC_FOLDER/cpprestsdk
CPPRESTSDK_PREFIX=$EXTERNAL_FOLDER/cpprestsdk
CPPRESTSDK_BUILD=$TMP_FOLDER/cpprestsdk
if [ ! -d $CPPRESTSDK_SRC ]; then
    cd $SRC_FOLDER
    $GIT clone $CPPRESTSDK_GIT
fi

cd $CPPRESTSDK_SRC
# $GIT fetch -a
# $GIT checkout hungptit
# $GIT merge master
$GIT pull

# Build Casablanca
rm -rf $CPPRESTSDK_BUILD
mkdir $CPPRESTSDK_BUILD
cd $CPPRESTSDK_BUILD
# $CMAKE $CPPRESTSDK_SRC/Release -DCMAKE_INSTALL_PREFIX=$CPPRESTSDK_PREFIX $CMAKE_RELEASE_BUILD $CMAKE_USE_CLANG -DBOOST_ROOT=/local/projects/3p/boost/ -DBoost_USE_MULTITHREADED=ON -DBUILD_SHARED_LIBS=0

$CMAKE $CPPRESTSDK_SRC/Release -DCMAKE_INSTALL_PREFIX=$CPPRESTSDK_PREFIX $CMAKE_RELEASE_BUILD $CMAKE_USE_CLANG -DBoost_USE_MULTITHREADED=ON -DBUILD_SHARED_LIBS=0

make $BUILD_OPTS
rm -rf $CPPRESTSDK_PREFIX
make install
