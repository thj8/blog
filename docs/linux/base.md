## 安装常用软件

```
sudo yum -y install zsh vim curl wget net-tools lsof nmap-ncat.x86_64
sudo yum -y install git
```

## zsh

```shell
sudo yum install zsh
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
```

## python虚拟环境

```shell
pip install virtualenv
pip install virtualenvwrapper
source /usr/bin/virtualenvwrapper.sh

mkvirtualenv -p python3 p3        # 指定python3的虚拟环境
mkvirtualenv thj                  # 默认python2.7的虚拟环境

```

