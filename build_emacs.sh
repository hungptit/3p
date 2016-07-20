#!/bin/bash
setup() {
    PROJECTS_FOLDER=$PWD
    SRC_FOLDER=$PWD/src/
    NCPUS=$(grep -c ^processor /proc/cpuinfo)
    BUILD_OPTS=-j$((NCPUS+1))
    EMACS_PREFIX=$PROJECTS_FOLDER/emacs
    mkdir -p $EMACS_PREFIX

    HG=$PROJECTS_FOLDER/mercurial-3.2.4/hg
    if [ ! -f $HG ]; then
        HG=hg
    fi


    GIT_PREFIX=$EXTERNAL_FOLDER/git
    GIT=$GIT_PREFIX/bin/git
    if [ ! -f $GIT ]; then
        # Use system CMake if we could not find the customized CMake.
        GIT=git
    fi
}

install_pkg() {
    PKG=$1
    PKG_GIT=$2
    PKG_FOLDER=$EMACS_PREFIX/$PKG
    cd $EMACS_PREFIX
    if [ ! -d $PKG_FOLDER ]; then
        git clone $PKG_GIT $PKG
    fi
    cd $PKG_FOLDER
    git pull
}

make_pkg() {
    PKG=$1
    OPTIONS=$2
    PKG_FOLDER=$EMACS_PREFIX/$PKG
    cd $PKG_FOLDER
    make $OPTIONS
}

install_cedet() {
    PKG=cedet
    install_pkg $PKG $1
    
    PKG_FOLDER=$EMACS_PREFIX/$PKG
    cd $PKG_FOLDER
    
    # Cleanup old files
    make clean-all
    git reset --hard
    git clean -f

    # Build cedet with one thread to avoid of potential build problem.
    make EMACS=emacs all
}

install_doxymacs() {
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
}

install_let_alist() {
    cd $EMACS_PREFIX/flycheck
    LET_ALIST_LINK=http://elpa.gnu.org/packages/let-alist-1.0.4.el
    wget $LET_ALIST_LINK
    mv let-alist-1.0.4.el let-alist.el
}

install_irony() {
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
}

# Install required packages.
setup;

install_pkg cask https://github.com/cask/cask
install_pkg popup https://github.com/auto-complete/popup-el.git;
install_pkg fuzzy https://github.com/auto-complete/fuzzy-el.git;
install_cedet http://git.code.sf.net/p/cedet/git
install_pkg autocomplete https://github.com/auto-complete/auto-complete.git
install_pkg helm https://github.com/emacs-helm/helm.git
make_pkg helm "-j3"
install_pkg ag https://github.com/Wilfred/ag.el.git
install_pkg helm_ag https://github.com/syohex/emacs-helm-ag.git
install_pkg projectile https://github.com/bbatsov/projectile.git
install_pkg helm_projectile https://github.com/bbatsov/helm-projectile.git
install_pkg helm_gtags https://github.com/syohex/emacs-helm-gtags
install_pkg async https://github.com/jwiegley/emacs-async.git
install_pkg function_args https://github.com/abo-abo/function-args.git
install_pkg dash https://github.com/magnars/dash.el

# Magit
install_pkg git_modes https://github.com/magit/git-modes.git
install_pkg with_editor https://github.com/magit/with-editor.git
make_pkg with_editor ""
install_pkg magit git://github.com/magit/magit.git
make_pkg magit "lisp docs"

install_pkg yasnippet https://github.com/capitaomorte/yasnippet.git
install_pkg json_mode https://github.com/joshwnj/json-mode.git
install_pkg json_reformat https://github.com/gongo/json-reformat.git
install_pkg json_snatcher https://github.com/Sterlingg/json-snatcher.git
install_doxymacs;
install_pkg flycheck https://github.com/flycheck/flycheck.git;
install_let_alist;              # Install let-alist to flycheck folder.
install_pkg seq https://github.com/NicolasPetton/seq.el
install_pkg rainbow_delimiters https://github.com/Fanael/rainbow-delimiters.git
install_pkg undo_tree http://www.dr-qubit.org/git/undo-tree.git
install_pkg smartparens https://github.com/Fuco1/smartparens.git
install_pkg zenburn https://github.com/bbatsov/zenburn-emacs.git
install_pkg markdown_mode https://github.com/defunkt/markdown-mode/
install_pkg graphviz_dot_mode https://github.com/ppareit/graphviz-dot-mode.git
install_pkg helm-themes https://github.com/syohex/emacs-helm-themes
install_pkg matlab-mode git://git.code.sf.net/p/matlab-emacs/src matlab-emacs-src
install_pkg web-beautify https://github.com/yasuyk/web-beautify
