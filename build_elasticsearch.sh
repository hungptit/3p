#!/bin/bash
EXTERNAL_FOLDER=$(pwd)
SRC_FOLDER=$EXTERNAL_FOLDER/src
TMP_FOLDER=/tmp/build/

mkdir -p $TMP_FOLDER
mkdir -p $SRC_FOLDER

NCPUS=$(grep -c ^processor /proc/cpuinfo)
BUILD_OPTS=-j$((NCPUS+1))

CMAKE_PREFIX=$EXTERNAL_FOLDER/cmake
CMAKE=$CMAKE_PREFIX/bin/cmake
CLANG=$EXTERNAL_FOLDER/llvm/bin/clang
CLANGPP=$EXTERNAL_FOLDER/llvm/bin/clang++
CMAKE_RELEASE_BUILD="-DCMAKE_BUILD_TYPE:STRING=Release"
CMAKE_USE_CLANG="-DCMAKE_CXX_COMPILER=${CLANGPP} -DCMAKE_C_COMPILER=${CLANG}"

GIT_PREFIX=$EXTERNAL_FOLDER/git
GIT=$GIT_PREFIX/bin/git

BOOST_PREFIX=$EXTERNAL_FOLDER/boost

# Build elasticsearch
ELASTICSEARCH_GIT=https://github.com/elasticsearch/elasticsearch.git
ELASTICSEARCH_PREFIX=$EXTERNAL_FOLDER/elasticsearch
ELASTICSEARCH_FOLDER=$SRC_FOLDER/elasticsearch

# We will build elasticsearch in the 3p folder.
cd $SRC_FOLDER
if [ ! -d $ELASTICSEARCH_FOLDER ]; then
    git clone $ELASTICSEARCH_GIT
fi

cd $ELASTICSEARCH_FOLDER
git checkout master
git pull

# If the java version is too old then we can download oracle jdk and set the
# JAVA_HOME variable to a desired folder.
mvn clean package  -DskipTests

# Now unzip elasticsearch to a desired folder.
cd $EXTERNAL_FOLDER
rm -rf elasticsearch
tar xf $ELASTICSEARCH_FOLDER/target/releases/elasticsearch*.tar.gz 
mv elasticsearch* elasticsearch
