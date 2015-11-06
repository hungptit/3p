This is a collection of scripts that automatically build tools and packages for my daily work.
========================================================================================

# Emacs #

## Build_emacs_bin.sh will build commands required by Emacs packages such as **the_silver_seracher** etc. Below are steps: ##

## Update the environment variables and path. Below is the sample from my **.cshrc.mine** ##

`set LLVM_DIR = /local/projects/3p/llvm/bin
set EMACS_DIR = /local/projects/3p/emacs/bin
set DOXYGEN_DIR = /local/projects/3p/doxygen/bin
set AG_DIR = /local/projects/3p/emacs/the_silver_searcher/bin
set ST_GIT = /local/projects/3p/emacs/stgit/bin
set CASH_DIR = /local/projects/3p/emacs/cask/bin
set JAVA_HOME = /local/projects/3p/jdk/bin
set NODE_FOLDER = /local/projects/3p/node/bin
set IRONY_MODE = /local/projects/3p/emacs/irony-mode/build/bin
set FILEOWNERSHIP = /hub/share/apps/iat/devapps/file-ownership/prod/bin
set CMAKE_DIR = /local/projects/3p/cmake/bin
set SQLITEBROWSER_DIR = /local/projects/3p/sqlitebrowser/bin
set DOXYMACS_DIR = /local/projects/3p/emacs/doxymacs/bin
set path = ($LLVM_DIR $AG_DIR $CASH_DIR $ST_GIT $DOXYGEN_DIR $JAVA_HOME $NODE_FOLDER $CMAKE_DIR $SQLITEBROWSER_DIR $DOXYMACS_DIR $path)`

## Run build_emacs.sh ##

## Update your .emacs to use installed extension ##

`(setq emacs-setup-root-path (file-name-as-directory "/local/projects/3p/emacs/"))
(load-file (concat emacs-setup-root-path "setup_cedet.el"))
(load-file (concat emacs-setup-root-path "setup.el"))
(load-file (concat emacs-setup-root-path "setup_helm.el"))
(load-file (concat emacs-setup-root-path "extra_features.el"))
`

# Basic tools #
build_tools.sh will build all required tools for C++ development including git, CMake etc.

# Userfull C++ libraries #
build_cpptools.sh will build useful packages that I often use for my personal work.

# LLVM #
build_llvm.sh will automatically build the latest LLVM tooling from latest source. 

# Boost #
build_boost.sh will automatically build all latest boost libraries from the git source.

# Google packages #
build_google.sh will build leveldb, gtest, sparsehash etc.

# Facebook packages #
build_rockssb.sh will autmatically build the latest version of rocksdb.
