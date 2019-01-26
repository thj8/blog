## mac 安装ftp命令
```
brew install telnet
brew install inetutils
brew link --overwrite inetutils
```

## centos 搭建ftp服务器
用户名ftp 密码ftp

```
yum install -y vsftpd
systemctl enable vsftpd.service

# config
sed -i 's/anonymous_enable=YES/anonymous_enable=No/g' /etc/vsftpd/vsftpd.conf
mkdir -p /home/ftp
/usr/sbin/adduser -d /home/ftp -g ftp -s /sbin/nologin ftp
echo 'local_root=/home/ftp' >> /etc/vsftpd/vsftpd.conf
echo 'ftp:ftp' | chpasswd
chown ftp:ftp /home/ftp
chmod 755 /home/ftp

systemctl restart vsftpd.service
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config

# close selinux
setenforce 0
```
