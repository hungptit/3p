This is a collection of scripts that automatically build tools and packages for my daily work.
========================================================================================

# Emacs #

First we need to run **build_emacs_bin.sh** to get all utilities required by Emacs packages such as **the_silver_seracher**, **global**, and **ctags**. After that we need to update path. Below is the sample from my `.cshrc.mine`.

`set AG_DIR = /local/projects/3p/emacs/the_silver_searcher/bin`

`set ST_GIT = /local/projects/3p/emacs/stgit/bin`

`set CASH_DIR = /local/projects/3p/emacs/cask/bin`

`set IRONY_MODE = /local/projects/3p/emacs/irony-mode/build/bin`

`set DOXYMACS_DIR = /local/projects/3p/emacs/doxymacs/bin`

`set path = ($AG_DIR $CASH_DIR $ST_GIT $IRONY_MODE $DOXYMACS_DIR $path)`

<!-- And this is my **.bashrc** file -->

<!-- PROJECTS_FOLDER=$HOME/projects/ -->
<!-- EXTERNAL_FOLDER=$PROJECTS_FOLDER/3p -->
<!-- EMACS_FOLDER=$EXTERNAL_FOLDER/emacs -->
<!-- CASK_FOLDER=$EMACS_FOLDER/cask/bin -->
<!-- AG_FOLDER=$EMACS_FOLDER/the_silver_searcher/bin -->
<!-- ELASTICSEARCH=$EXTERNAL_FOLDER/elasticsearch/bin -->
<!-- ATOM_FOLDER=$EXTERNAL_FOLDER/atom/bin -->
<!-- NODE_FOLDER=$EXTERNAL_FOLDER/node/bin -->
<!-- LLVM=$EXTERNAL_FOLDER/llvm/bin -->
<!-- GLOBAL=$EXTERNAL_FOLDER/global/bin -->
<!-- CTAGS=$EXTERNAL_FOLDER/ctags/bin -->
<!-- SQLITEBROWSER=$EXTERNAL_FOLDER/sqlitebrowser/bin -->
<!-- TOOLS=$PROJECTS_FOLDER/tools/testing -->

<!-- # Update paths -->
<!-- PATH=$CTAGS:$GLOBAL:$LLVM:${NODE_FOLDER}:${ELASTICSEARCH}:${ATOM_FOLDER}:${CASK_FOLDER}:${AG_FOLDER}:${PATH}:${TOOLS}:${SQLITEBROWSER} -->


Run **build_emacs.sh** after your path is updated (using source command or open a new terminal) to install required Emacs extensions such has **Helm**, **auto-complete**, and **CEDET**. Then remember to update the `.emacs` file to use all installed Emacs extensions. This is an example of my `.emacs`.

`(setq emacs-setup-root-path "/home/hungptit/projects/3p/emacs/")`

`(add-to-list 'load-path (concat emacs-setup-root-path))`

`(require 'init)`

*Tip: You can comment out some options in init.el to fit the default settings for your need.*

# Basic tools #
**build_tools.sh** will build all required tools for C++ development including **git**, **CMake** etc.

# Userfull C++ libraries #
**build_cpptools.sh** will build useful packages that I often use for my personal work.

# LLVM #
**build_llvm.sh** will automatically build **LLVM** from source. 

# Boost #
**build_boost.sh** will automatically build **Boost** libraries from the git source.

# Google packages #
**build_google.sh** will build **leveldb**, **gtest**, **sparsehash** etc.

# Facebook packages #
**build_rockssb.sh** will autmatically build the latest version of **rocksdb** and **folly**.
