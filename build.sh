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

# Build elasticsearch
ELASTICSEARCH_GIT=https://github.com/elasticsearch/elasticsearch.git
ELASTICSEARCH_PREFIX=$PROJECTS_FOLDER/elasticsearch
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
cd $PROJECTS_FOLDER
rm -rf elasticsearch
tar xf $ELASTICSEARCH_FOLDER/target/releases/elasticsearch*.tar.gz 
mv elasticsearch* elasticsearch

# Node.js
NODE_GIT=https://github.com/joyent/node.git
NODE_FOLDER=$SRC_FOLDER/node
NODE_PREFIX=$PROJECTS_FOLDER/node

cd $SRC_FOLDER
if [ ! -d $NODE_FOLDER ]; then
    git clone $NODE_GIT
fi
cd $NODE_FOLDER
git pull
git checkout origin/v0.12.0-release

./configure --prefix=$NODE_PREFIX --dest-cpu=x64 --dest-os=linux
make $BUILD_OPTS
make install

# Atom
ATOM_GIT=https://github.com/atom/atom
ATOM_FOLDER=$SRC_FOLDER/atom
ATOM_PREFIX=$PROJECTS_FOLDER/atom

cd $SRC_FOLDER
if [ ! -d $ATOM_FOLDER ]; then
    git clone $ATOM_GIT
fi
cd $ATOM_FOLDER
git pull

# Build atom
# Note: Need to install libgnome-keyring-dev before building atom.
script/build
script/grunt install --install-dir $ATOM_PREFIX

