## 设置混杂模式
```
ip link  set enp3s0f1 promisc on
```
## 设置ip_forward
```
➜  ~ more /etc/sysctl.conf
net.ipv4.ip_forward=1
```

## 创建桥接网络

```
docker network create -d macvlan --subnet 172.16.1.0/24 --gateway 172.16.1.254 -o parent=enp3s0f1.1001 -o macvlan_mode=bridge team1
```

## 配置vlan网卡
```
➜  network-scripts more ifcfg-enp3s0f1.1001
DEVICE=enp3s0f1.1001
BOOTPROTO=none
ONBOOT=yes
VLAN=yes   
```

# 启动docker
```
docker run -id --net team1 --ip 172.16.1.101 --name team_1_1 ubuntu /bin/bash
```

