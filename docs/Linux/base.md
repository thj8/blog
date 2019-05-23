## 安装常用软件

```
sudo yum -y install vim curl wget net-tools lsof nmap-ncat.x86_64
sudo yum -y install git
sudo yum -y install gcc
```

## oh my zsh

```shell
sudo yum -y install zsh
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

## yum阿里源

```
yum install -y wget
if [[ `cat /etc/yum.repos.d/CentOS-Base.repo|grep aliyun | wc -l` -eq 0 ]]; then
    cd /etc/yum.repos.d/
    mv CentOS-Base.repo CentOS-Base.repo_bak
    wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
    cd /tmp
fi
```

## tmux

```
yum -y install libevent-devel
yum -y install ncurses-devel
yum -y install automake

cd /tmp
git clone https://github.com/tmux/tmux.git
cd tmux
sh autogen.sh
./configure
make
make install


cd
git clone https://github.com/gpakosz/.tmux.git
ln -s -f .tmux/.tmux.conf
cp .tmux/.tmux.conf.local .

cat <<EOF >> ~/.tmux.conf.local
set-option -g prefix C-a
unbind-key C-a
bind-key C-a send-prefix
setw -g mode-keys vi
EOF
```

## iptables

```
service iptables status
yum install -y iptables
yum update iptables 
yum install -y iptables-services

systemctl stop firewalld
systemctl mask firewalld
```
