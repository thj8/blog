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
yum -y install libevent-devel ncurses-devel
yum -y install automake
yum -y install byacc flex

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

## yum
使用--showduplicates参数列出所有版本
```
➜  cr git:(develop) ✗ ssh root@172.29.100.191
Last login: Tue Aug 13 17:46:01 2019 from 192.168.100.102
[root@tinyFat ~]# yum list docker-ce --showduplicates
Loaded plugins: fastestmirror
Loading mirror speeds from cached hostfile
 * base: mirrors.aliyun.com
 * epel: mirrors.yun-idc.com
 * extras: mirrors.aliyun.com
 * updates: mirrors.aliyun.com
Installed Packages
docker-ce.x86_64                           3:18.09.6-3.el7                                    @docker-ce-stable
Available Packages
docker-ce.x86_64                           17.03.0.ce-1.el7.centos                            docker-ce-stable
docker-ce.x86_64                           17.03.1.ce-1.el7.centos                            docker-ce-stable
docker-ce.x86_64                           17.03.2.ce-1.el7.centos                            docker-ce-stable
docker-ce.x86_64                           17.03.3.ce-1.el7                                   docker-ce-stable
docker-ce.x86_64                           17.06.0.ce-1.el7.centos                            docker-ce-stable
docker-ce.x86_64                           17.06.1.ce-1.el7.centos                            docker-ce-stable
docker-ce.x86_64                           17.06.2.ce-1.el7.centos                            docker-ce-stable
docker-ce.x86_64                           17.09.0.ce-1.el7.centos                            docker-ce-stable
docker-ce.x86_64                           17.09.1.ce-1.el7.centos                            docker-ce-stable
docker-ce.x86_64                           17.12.0.ce-1.el7.centos                            docker-ce-stable
docker-ce.x86_64                           17.12.1.ce-1.el7.centos                            docker-ce-stable
docker-ce.x86_64                           18.03.0.ce-1.el7.centos                            docker-ce-stable
docker-ce.x86_64                           18.03.1.ce-1.el7.centos                            docker-ce-stable
docker-ce.x86_64                           18.06.0.ce-3.el7                                   docker-ce-stable
docker-ce.x86_64                           18.06.1.ce-3.el7                                   docker-ce-stable
docker-ce.x86_64                           18.06.2.ce-3.el7                                   docker-ce-stable
docker-ce.x86_64                           18.06.3.ce-3.el7                                   docker-ce-stable
docker-ce.x86_64                           3:18.09.0-3.el7                                    docker-ce-stable
docker-ce.x86_64                           3:18.09.1-3.el7                                    docker-ce-stable
docker-ce.x86_64                           3:18.09.2-3.el7                                    docker-ce-stable
docker-ce.x86_64                           3:18.09.3-3.el7                                    docker-ce-stable
docker-ce.x86_64                           3:18.09.4-3.el7                                    docker-ce-stable
docker-ce.x86_64                           3:18.09.5-3.el7                                    docker-ce-stable
docker-ce.x86_64                           3:18.09.6-3.el7                                    docker-ce-stable
docker-ce.x86_64                           3:18.09.7-3.el7                                    docker-ce-stable
docker-ce.x86_64                           3:18.09.8-3.el7                                    docker-ce-stable
docker-ce.x86_64                           3:19.03.0-3.el7                                    docker-ce-stable
docker-ce.x86_64                           3:19.03.1-3.el7                                    docker-ce-stable
```
