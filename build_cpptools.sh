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

install_tbb() {
    TBB_LINK=https://www.threadingbuildingblocks.org/sites/default/files/software_releases/source/tbb43_20150316oss_src.tgz
    TBB_PREFIX=$EXTERNAL_FOLDER/tbb
    TBB_FILE=tbb43_20150316oss_src.tgz

    if [ ! -f $TBB_FILE ]; then
        wget $TBB_LINK
    fi

    # Install TBB
    TBB_LINK=https://www.threadingbuildingblocks.org/sites/default/files/software_releases/linux/tbb43_20150316oss_lin.tgz
    TBB_PREFIX=$EXTERNAL_FOLDER/tbb
    TBB_FILE=tbb43_20150316oss_lin.tgz

    if [ ! -f $TBB_FILE ]; then
        wget --no-check-certificate $TBB_LINK
    fi

    rm -rf $TBB_PREFIX
    tar xf $TBB_FILE
    mv tbb43_20150316oss $TBB_PREFIX
}

install_eigen() {
    EIGEN_SRC=$SRC_FOLDER/eigen
    EIGEN_BUILD_FOLDER=$TMP_FOLDER/eigen/
    EIGEN_PREFIX=$EXTERNAL_FOLDER/eigen

    MERCURIAL_VERSION=3.2.4
    MERCURIAL_PREFIX=$EXTERNAL_FOLDER/mercurial
    MERCURIAL=$MERCURIAL_PREFIX-$MERCURIAL_VERSION/hg

    cd $SRC_FOLDER
    if [ -d $EIGEN_SRC ];
    then
        cd $EIGEN_SRC
        $MERCURIAL pull
        $MERCURIAL update
    else
        cd $SRC_FOLDER
        $MERCURIAL clone https://bitbucket.org/eigen/eigen/
        cd $EIGEN_SRC
    fi
    rm -rf $EIGEN_BUILD_FOLDER
    mkdir $EIGEN_BUILD_FOLDER
    cd $EIGEN_BUILD_FOLDER
    $CMAKE $EIGEN_SRC -DCMAKE_INSTALL_PREFIX=$EIGEN_PREFIX $CMAKE_RELEASE_BUILD
    make install $BUILD_OPTS
    rm -rf $EIGEN_BUILD_FOLDER    
}

build_libmemcached() {
    LIBMEMCACHED_LINK=https://launchpad.net/libmemcached/1.0/1.0.18/+download/libmemcached-1.0.18.tar.gz
    LIBMEMCACHED_FILE=libmemcached-1.0.18.tar.gz
    LIBMEMCACHED_FOLDER=$SRC_FOLDER/libmemcached-1.0.18
    LIBMEMCACHED_PREFIX=$EXTERNAL_FOLDER/libmemcached

    if [ ! -f $LIBMEMCACHED_FILE ]; then
        cd $SRC_FOLDER
        tar xf $LIBMEMCACHED_FILE
    fi

    cd $LIBMEMCACHED_FOLDER
    ./configure --prefix=$LIBMEMCACHED_PREFIX --with-memcached=$MEMCACHED_PREFIX
    make $BUILD_OPTS
    rm -rf $LIBMEMCACHED_PREFIX
    make install
}

build_casablanca() {
    CPPRESTSDK_GIT=https://github.com/Microsoft/cpprestsdk.git
    CPPRESTSDK_SRC=$SRC_FOLDER/cpprestsdk
    CPPRESTSDK_PREFIX=$EXTERNAL_FOLDER/cpprestsdk
    CPPRESTSDK_BUILD=$TMP_FOLDER/cpprestsdk
    if [ ! -d $CPPRESTSDK_SRC ]; then
        cd $SRC_FOLDER
        $GIT clone $CPPRESTSDK_GIT
    fi

    cd $CPPRESTSDK_SRC
    $GIT fetch -a
    $GIT checkout hungptit      # Apply fix for clang
    $GIT merge master
    $GIT pull

    # Build Casablanca
    rm -rf $CPPRESTSDK_BUILD
    mkdir $CPPRESTSDK_BUILD
    cd $CPPRESTSDK_BUILD

    # Use customized boost libraries
    # $CMAKE $CPPRESTSDK_SRC/Release -DCMAKE_INSTALL_PREFIX=$CPPRESTSDK_PREFIX $CMAKE_RELEASE_BUILD -DBOOST_ROOT=$EXTERNAL_FOLDER/boost/ -DBoost_USE_MULTITHREADED=ON -DBUILD_SHARED_LIBS=0 $CMAKE_USE_CLANG 

    $CMAKE $CPPRESTSDK_SRC/Release -DCMAKE_INSTALL_PREFIX=$CPPRESTSDK_PREFIX $CMAKE_RELEASE_BUILD -DBOOST_ROOT=$EXTERNAL_FOLDER/boost/ -DBoost_USE_MULTITHREADED=ON -DBUILD_SHARED_LIBS=0

    # Use system boost libraries
    # $CMAKE $CPPRESTSDK_SRC/Release -DCMAKE_INSTALL_PREFIX=$CPPRESTSDK_PREFIX $CMAKE_RELEASE_BUILD $CMAKE_USE_CLANG -DBoost_USE_MULTITHREADED=ON -DBUILD_SHARED_LIBS=0

    make $BUILD_OPTS
    rm -rf $CPPRESTSDK_PREFIX
    make install
}

echo "Install doxygen"
sh build_using_cmake.sh $EXTERNAL_FOLDER doxygen https://github.com/doxygen/doxygen.git "" > /dev/null

echo "Install cereal"
sh install_pkg.sh $EXTERNAL_FOLDER cereal https://github.com/USCiLab/cereal > /dev/null

echo "Install rapidjson"
sh install_pkg.sh $EXTERNAL_FOLDER rapidjson https://github.com/miloyip/rapidjson > /dev/null

echo "Install splog"
sh install_pkg.sh $EXTERNAL_FOLDER splog https://github.com/gabime/spdlog.git > /dev/null

echo "Install cppformat"
sh build_using_cmake.sh $EXTERNAL_FOLDER fmt https://github.com/fmtlib/fmt.git "" > /dev/null

echo "Install TBB"
install_tbb > /dev/null

echo "Install eigen"
install_eigen > /dev/null

echo "Install libevent and memcached"
sh build_using_autogen.sh libevent git://levent.git.sourceforge.net/gitroot/levent/libevent > /dev/null
sh build_using_autogen.sh memcached git://github.com/memcached/memcached.git "--with-libevent=$EXTERNAL_FOLDER/libevent" > /dev/null
build_libmemcached > /dev/null

# echo "Build Casablanca"
# build_casablanca;

# Build HDF5
# HDF5_FILE=hdf5-1.8.10
# HDF5_GIT=https://gitorious.org/hdf5/hdf5-v18.git
# HDF5_SRC=$SRC_FOLDER/hdf5-v18
# HDF5_PREFIX=$EXTERNAL_FOLDER/hdf5

# if [ ! -d $HDF5_SRC  ]; then
#     git clone $HDF5_GIT
# fi

# # Check out the latest version
# cd $HDF5_SRC
# git pull;

# # Now build and install the library
# ./configure --prefix=$HDF5_PREFIX --with-zlib=$ZLIB_PREFIX --enable-hl --enable-production --enable-cxx --enable-static-exec --enable-shared=0
# make $BUILD_OPTS
# rm -rf $HDF5_PREFIX
# make install
