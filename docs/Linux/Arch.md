# Archlinux

## 检查网络
```
root@archiso ~ # ip ad                                                                           
1: lo:  mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: ens33:  mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 00:0c:29:83:ed:00 brd ff:ff:ff:ff:ff:ff
    altname enp2s1
    inet 192.168.43.154/24 brd 192.168.43.255 scope global dynamic noprefixroute ens33
       valid_lft 1706sec preferred_lft 1481sec
    inet6 fe80::456b:5cf2:4baa:efd8/64 scope link 
       valid_lft forever preferred_lft forever
```

## 创建分区

```
// 查看硬盘
fdisk -l

// 创建分区
ddisk /dev/sda 
n p 一路回车  w保存
```

## 格式化分区 并挂载分区
```
mkfs.ext4 /dev/sda1
mount /dev/sda1 /mnt
```

## 修改镜像源
/etc/pacman.d/mirrorlist 改为国内镜像

## 安装必须的安装包
```
pacstrap /mnt base linux linux-firmware dhcpcd vim openssh xfsprogs man net-tools
```

## 生成fstab文件
```
genfstab -U /mnt >> /mnt/etc/fstab  

cat /mbt/etc/fstab
```

## 更改根目录
```
arch-chroot /mnt
```

## 更改时区
```
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
hwclock -w
```

## 设置本地化文本编码
```
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
echo LANG=en_US.UTF-8 > /etc/locale.conf
```

## 修改root密码
```
passwd root
```

## 设置开机启动项
```
systemctl enable dhcpcd
systemctl enable sshd
```

## 安装并配置grub引导
```
pacman -S grub

grub-install /dev/sda

grub-mkconfig -o /boot/grub/grub.cfg
```

## 配置完成
```
[root@Archone /]# exit
root@archiso ~ # reboot
``` 

## 修改ssh配置, 允许root用户
```
[root@arch-one ~]# sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config
[root@arch-one ~]# systemctl restart sshd
```
