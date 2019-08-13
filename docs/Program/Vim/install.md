 # 在centos上源代码安装vim
 function compile_vim_on_centos()
 {
     sudo rm -rf /usr/bin/vi
     sudo rm -rf /usr/bin/vim*
     sudo rm -rf /usr/local/bin/vim*
     sudo rm -rf /usr/share/vim/vim*
     sudo rm -rf /usr/local/share/vim/vim*
     rm -rf ~/vim
 
     sudo yum install -y ruby ruby-devel lua lua-devel luajit \
         luajit-devel ctags git python python-devel \
         python34 python34-devel tcl-devel \
         perl perl-devel perl-ExtUtils-ParseXS \
         perl-ExtUtils-XSpp perl-ExtUtils-CBuilder \
         perl-ExtUtils-Embed libX11-devel ncurses-devel
 
     git clone https://github.com/vim/vim.git ~/vim
     cd ~/vim
     ./configure --with-features=huge \
         --enable-multibyte \
         --with-tlib=tinfo \
         --enable-rubyinterp=yes \
         --enable-pythoninterp=yes \
         --with-python-config-dir=/usr/local/python-2.7.14/lib/python2.7/config \
         --enable-perlinterp=yes \
         --enable-luainterp=yes \
         --enable-gui=gtk2 \
         --enable-cscope \
         --prefix=/usr
     make
     sudo make install
     cd -
 }
