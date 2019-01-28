# ale

## 安装

### 介绍

各种语言的检查，修改插件，每种语言的检查命令是要单独安装。

ALE (Asynchronous Lint Engine) is a plugin for providing linting in NeoVim 0.2.0+ and Vim 8 while you edit your text files, and acts as a Vim [Language Server Protocol](https://langserver.org/) client.

`vim-flake8` is a Vim plugin that runs the currently open file through Flake8, a static syntax and style checker for Python source code.  It supersedes both [vim-pyflakes](https://github.com/nvie/vim-pyflakes) and [vim-pep8](https://github.com/nvie/vim-pep8).  

[Flake8](https://pypi.python.org/pypi/flake8/) is a wrapper around PyFlakes (static syntax checker), PEP8 (style checker) and Ned's MacCabe script (complexity checker).


### 配置vimrc文件
现在.vimrc文件中，plug处添加插件名

```
Plug 'w0rp/ale'
Plug 'nvie/vim-flake8'            # python检查插件
```

### 安装插件
```
:PlugInstall                      # 等待安装成功

```

### 安装检查命令
python 建议使用flake8, 安装方法如下

```
pip install flake8
```

> Flake8是对下面三个工具的封装：

> 1）PyFlakes：静态检查Python代码逻辑错误的工具。

> 2）Pep8： 静态检查PEP8编码风格的工具。

> 3）NedBatchelder’s McCabe script：静态分析Python代码复杂度的工具。

