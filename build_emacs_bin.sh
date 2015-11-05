# ********************************
#  Build emacs related packages  *
# ********************************
#!/bin/bash
PROJECTS_FOLDER=$PWD
SRC_FOLDER=$PROJECTS_FOLDER/src/
NCPUS=$(grep -c ^processor /proc/cpuinfo)
BUILD_OPTS=-j$((NCPUS+1))
EMACS_PREFIX=$PROJECTS_FOLDER/emacs
mkdir -p $EMACS_PREFIX

# Build Emacs
# EMACS_FOLDER=$PROJECTS_FOLDER/emacs
# EMACS_LINK=git://git.savannah.gnu.org/emacs.git
# EMACS_PREFIX=$EXTERNAL_FOLDER/emacs
# cd $PROJECTS_FOLDER
# if [ ! -d $EMACS_FOLDER ]; then
#     git clone $EMACS_LINK
# fi

# # Now enter emacs source folder and build
# cd $EMACS_FOLDER
# git checkout master
# git pull
# ./configure --prefix=$EMACS_PREFIX --with-x
# make $BUILD_OPTS
# make install

# stgit
STGIT_FILE=stgit-0.17.tar.gz
STGIT_GIT_LINK=http://download.gna.org/stgit/$STGIT_FILE
STGIT_FOLDER=$EMACS_PREFIX/stgit
cd $SRC_FOLDER
if [ ! -f $STGIT_FILE ]; then
    wget $STGIT_GIT_LINK
fi
tar -xf $STGIT_FILE -C $EMACS_PREFIX
cd stgit-0.17
make prefix=$STGIT_FOLDER install

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
./configure --prefix=$SILVER_SEARCH_PREFIX
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

