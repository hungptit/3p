# ********************************
#  Build emacs related packages  *
# ********************************
#!/bin/bash
PROJECTS_FOLDER=$PWD
SRC_FOLDER=$PWD/src/
NCPUS=$(grep -c ^processor /proc/cpuinfo)
BUILD_OPTS=-j$((NCPUS+1))
EMACS_PREFIX=$PROJECTS_FOLDER/emacs
mkdir -p $EMACS_PREFIX

# Build popup
POPUP_GIT=https://github.com/auto-complete/popup-el.git
POPUP_FOLDER=$EMACS_PREFIX/popup

cd $EMACS_PREFIX
if [ ! -d $POPUP_FOLDER ]; then
    git clone $POPUP_GIT popup
fi

cd $POPUP_FOLDER
git pull

# Build fuzzy
FUZZY_GIT=https://github.com/auto-complete/fuzzy-el.git
FUZZY_FOLDER=$EMACS_PREFIX/fuzzy
cd $EMACS_PREFIX
if [ ! -d $FUZZY_FOLDER ]; then
    git clone $FUZZY_GIT fuzzy
fi

cd $FUZZY_FOLDER
git pull

# Build CEDET
CEDET_FOLDER=$EMACS_PREFIX/cedet
CEDET_GIT=http://git.code.sf.net/p/cedet/git

# Check out the latest source code
cd $EMACS_PREFIX
if [ ! -d $CEDET_FOLDER ]; then
    git clone $CEDET_GIT cedet
fi
cd $CEDET_FOLDER
git pull

# Cleanup old files
make clean-all
git reset --hard
git clean -f

# Build cedet with one thread to avoid of potential build problem.
make EMACS=emacs all

# Build auto-complete
AUTOCOMPLETE_FOLDER=$EMACS_PREFIX/autocomplete
AUTOCOMPLETE_GIT=https://github.com/auto-complete/auto-complete.git
cd $EMACS_PREFIX
if [ ! -d $AUTOCOMPLETE_FOLDER ]; then
    git clone $AUTOCOMPLETE_GIT autocomplete
fi
cd $AUTOCOMPLETE_FOLDER
git pull

# Get helm
HELM_GIT=https://github.com/emacs-helm/helm.git
HELM_FOLDER=$EMACS_PREFIX/helm
cd $EMACS_PREFIX
if [ ! -d $HELM_FOLDER ]; then
    git clone $HELM_GIT
fi
cd $HELM_FOLDER
git pull
make -k

# Get async
ASYNC_GIT=https://github.com/jwiegley/emacs-async.git
ASYNC_FOLDER=$EMACS_PREFIX/emacs-async
cd $EMACS_PREFIX
if [ ! -d $ASYNC_FOLDER ]; then
    git clone $ASYNC_GIT
fi
cd $ASYNC_FOLDER
git pull

# ag
AG_GIT=https://github.com/Wilfred/ag.el.git
AG_FOLDER=$EMACS_PREFIX/ag.el
cd $EMACS_PREFIX
if [ ! -d $AG_FOLDER ]; then
    git clone $AG_GIT
fi
cd $AG_FOLDER
git pull

# helm-ag
HELMAG_GIT=https://github.com/syohex/emacs-helm-ag.git
HELMAG_FOLDER=$EMACS_PREFIX/emacs-helm-ag
cd $EMACS_PREFIX
if [ ! -d $HELMAG_FOLDER ]; then
    git clone $HELMAG_GIT
fi
cd $HELMAG_FOLDER
git pull
make -k

# Get function-args
FUNCARGS_GIT=https://github.com/abo-abo/function-args.git
FUNCARGS_FOLDER=$EMACS_PREFIX/function-args
cd $EMACS_PREFIX
if [ ! -d $FUNCARGS_FOLDER ]; then
    git clone $FUNCARGS_GIT
fi
cd $FUNCARGS_FOLDER
git pull

# git-modes
GITMODES_GIT=https://github.com/magit/git-modes.git
GITMODES_FOLDER=$EMACS_PREFIX/git-modes
cd $EMACS_PREFIX
if [ ! -d $GITMODES_FOLDER ]; then
    git clone $GITMODES_GIT
fi
cd $GITMODES_FOLDER
git pull
make -k

# Install dash
DASH_GIT=https://github.com/magnars/dash.el
DASH_FOLDER=$EMACS_PREFIX/dash
cd $EMACS_PREFIX
if [ ! -d $DASH_FOLDER ]; then
    git clone $DASH_GIT dash
fi
cd $DASH_FOLDER
git pull

# Install with-editor
WITH_EDITOR_GIT=https://github.com/magit/with-editor
WITH_EDITOR_FOLDER=$EMACS_PREFIX/with-editor
cd $EMACS_PREFIX
if [ ! -d $WITH_EDITOR_FOLDER ]; then
    git clone $WITH_EDITOR_GIT with-editor
fi
cd $WITH_EDITOR_FOLDER
git pull
make -j3

# magit
MAGIT_GIT=git://github.com/magit/magit.git
MAGIT_FOLDER=$EMACS_PREFIX/magit
cd $EMACS_PREFIX
if [ ! -d $MAGIT_FOLDER ]; then
    git clone $MAGIT_GIT
fi
cd $MAGIT_FOLDER
git pull
make lisp docs

# Install yasnippet
YASNIPPET_GIT=https://github.com/capitaomorte/yasnippet.git
YASNIPPET_FOLDER=$EMACS_PREFIX/yasnippet
cd $EMACS_PREFIX
if [ ! -d $YASNIPPET_FOLDER ]; then
    git clone --recursive $YASNIPPET_GIT
fi
cd $YASNIPPET_FOLDER
git pull

# irony-mode
IRONYMODE_GIT=https://github.com/Sarcasm/irony-mode.git
IRONYMODE_FOLDER=$EMACS_PREFIX/irony-mode
IRONYMODE_BUILD=$IRONYMODE_FOLDER/build
cd $EMACS_PREFIX
if [ ! -d $IRONYMODE_FOLDER ]; then
    git clone $IRONYMODE_GIT
fi
cd $IRONYMODE_FOLDER
git pull

# Build irony-server
mkdir -p $IRONYMODE_BUILD
rm -rf $IRONYMODE_BUILD/*
cd $IRONYMODE_BUILD
cmake ../server/ -DCMAKE_BUILD_TYPE=RELEASE -DCMAKE_INSTALL_RPATH_USE_LINK_PATH=ON
make $BUILD_OPTS

# ac-irony
AC_IRONY_GIT=https://github.com/Sarcasm/ac-irony.git
AC_IRONY_FOLDER=$EMACS_PREFIX/ac-irony
cd $EMACS_PREFIX
if [ ! -d $AC_IRONY_FOLDER ]; then
    git clone $AC_IRONY_GIT
fi
cd $AC_IRONY_FOLDER
git pull

# Projectile
PROJECTILE_GIT=https://github.com/bbatsov/projectile.git
PROJECTILE_FOLDER=$EMACS_PREFIX/projectile
cd $EMACS_PREFIX
if [ ! -d $PROJECTILE_FOLDER ]; then
    git clone $PROJECTILE_GIT
fi
cd $PROJECTILE_FOLDER
git pull

# json-mode
JSON_GIT=https://github.com/joshwnj/json-mode.git
JSON_FOLDER=$EMACS_PREFIX/json-mode
cd $EMACS_PREFIX
if [ ! -d $JSON_FOLDER ]; then
    git clone $JSON_GIT
fi
cd $JSON_FOLDER
git pull

# json-reformat
JSON_REFORMAT_GIT=https://github.com/gongo/json-reformat.git
JSON_REFORMAT_FOLDER=$EMACS_PREFIX/json-reformat
cd $EMACS_PREFIX
if [ ! -d $JSON_REFORMAT_FOLDER ]; then
    git clone $JSON_REFORMAT_GIT
fi
cd $JSON_REFORMAT_FOLDER
git pull

# json-snatcher
JSON_SNATCHER_GIT=https://github.com/Sterlingg/json-snatcher.git
JSON_SNATCHER_FOLDER=$EMACS_PREFIX/json-snatcher
cd $EMACS_PREFIX
if [ ! -d $JSON_SNATCHER_FOLDER ]; then
    git clone $JSON_SNATCHER_GIT
fi
cd $JSON_SNATCHER_FOLDER
git pull

# Doxymacs
DOXYMACS_GIT=https://github.com/emacsattic/doxymacs.git
DOXYMACS_SRC=$SRC_FOLDER/doxymacs
DOXYMACS_PREFIX=$EMACS_PREFIX/doxymacs
if [ ! -d $DOXYMACS_SRC ]; then
    cd $SRC_FOLDER
    git clone $DOXYMACS_GIT
fi
cd $DOXYMACS_SRC
git pull
./bootstrap
./configure --prefix=$DOXYMACS_PREFIX
make -j5
make install

# flycheck in its dependencies
FLYCHECK_GIT=https://github.com/flycheck/flycheck.git
FLYCHECK_FOLDER=$EMACS_PREFIX/flycheck
cd $EMACS_PREFIX
if [ ! -d $FLYCHECK_FOLDER ]; then
    git clone $FLYCHECK_GIT
fi
cd $FLYCHECK_FOLDER
git pull

# Download let-alist to flycheck folder.
LET_ALIST_LINK=http://elpa.gnu.org/packages/let-alist-1.0.4.el
wget $LET_ALIST_LINK
mv let-alist-1.0.4.el let-alist.el

# seq
SEQ_GIT=https://github.com/NicolasPetton/seq.el
SEQ_FOLDER=$EMACS_PREFIX/seq
cd $EMACS_PREFIX
if [ ! -d $SEQ_FOLDER ]; then
    git clone $SEQ_GIT seq
fi
cd $SEQ_FOLDER
git pull
