# Iptables

## 内网如何做对外服务器

本地(2网卡, 1外网 1内网,)80端口流量发送到-->内网192.168.1.1

```
iptables -t nat -A PREROUTING -i ppp0 -p tcp --dport 80 -j DNAT --to 192.168.1.1
iptables -t nat -A PREROUTING -i ppp0 -p tcp --dport 80 -j DNAT --to 192.168.1.1:80
```

## ip转发配置

```
// 临时生效
echo 1 > /proc/sys/net/ipv4/ip_forward

// 永久
net.ipv4.ip_forward = 1 
sysctl -p /etc/sysctl.conf
```

## 目标地址改写DNAT

原始dst 192.168.2.101:55

转发给 192.168.2.100:53

```
iptables -t nat -nvL

iptables -t nat -A OUTPUT -p tcp -d 192.168.2.101 --dport 55 -j DNAT --to-destination 192.168.2.100:53

iptables -t nat -D OUTPUT 1
```

## 禁用114.114.114.114 DNS 解析
```
iptables -t filter -A OUTPUT -p udp -d 114.114.114.114 -j DROP
iptables -f filter -D OUTPUT 1
```

## 连接跟踪文件 
cat /proc/net/nf_conntrack

## 网桥是什么

linux bridge ,虚拟交换机, 三层交换机

docker container --> bridge (软件概念)  --> eth0

## 地址改写表
conntrack -L 

## SNAT
把所有10.8.0.0网段的数据包SNAT成192.168.5.3的ip然后发出去
```
iptables-t nat -A POSTROUTING -s 10.8.0.0/255.255.255.0 -o eth0 -j SNAT --to-source192.168.5.3
```
如下命令表示把所有10.8.0.0网段的数据包SNAT成192.168.5.3/192.168.5.4/192.168.5.5等几个ip然后发出去

```
iptables-t nat -A POSTROUTING -s 10.8.0.0/255.255.255.0 -o eth0 -j SNAT --to-source192.168.5.3-192.168.5.5
```

## filter
filer表的控制是我们实现本机防火墙的重要手段, 特别是对input链的控制

- INPUT   负责过滤所有目标地址是本机的数据包,就是过滤进入主机的数据包
- FORWARD 负责转发流经主机的数据包, 起转发的作用, net.ipv4.ip_forward=1
- OUTPUT  负责所有源地址是本机地址的数据包, 就是处理从主机发出去的数据包

## nat
就是网络地址转换, 负责ip地址和port的转换, 一般用于局域网共享上网, 特殊端口和ip转换服务相关

- 企业路由 网关 共享上网(POSTROUTING)
- 做内部外部ip地址映射, 通过iptables防火墙映射ip到内部服务器,(PREROUTING)
- 单个端口的映射,(PREROUTING)

- OUTPUT       和主机发出去的数据包有关, 改变主机发出数据包的地址
- PREROUTING   **在数据包到达防火墙时进行路由判断之间执行的规则**, 作用是改变数据包的目的地址和目的端口(通俗的讲就是收信时, 根据规则重写收件人的地址, 这看上去不地道,例如把公网的数据包转到内网的某个ip的80端口
- POSTOUTING   **在数据包离开防火墙时进行路由判断之后执行的规则**,作用是改写数据包的源地址和源端口,例如路由器把源地址改为公网地址发送出去

## 实例

```
-n 数字
-L 列表
-F 清除所有规则
-X 删除用户自定义的链
-Z 链的计数器清零
-P 控制默认规则
-t 指定表
-A 添加到链的结尾, 最后一条
-I 添加规则到指定链的开头, 第一条
-p 协议
--dport 目的端口
--sport 源端口
-D 删除规则
-j jump处理的行为(ACCEPT, DROP, REJECT)
--line-number  显示序号
-i 指定网卡
-s 指定ip范围, 子网
```


禁止ssh连接
```
iptables -t filter -A INPUT -p port --dort 22 -j DROP
iptables -naL
iptables -nal --line-number
iptables -D INPUT 1

iptables -t filter -A INPUT 2 -p port --dort 80 -j DROP       // 第二行插入

iptables -A INPUT -s 10.10.10.0/24 -j DROP                  // ip范围
iptables -A INPUT ! -s 10.10.10.0/24 -j DROP                  // 非这个ip范围
  
iptables -A INPUT -p tcp --dport 500:600 -j DROP            // 端口范围

iptables -I INPUT -p icmp --icmp-type 8 DROP                // ping协议
iptables -I INPUT -p icmp --icmp-type any DROP              // 整个icmp协议
```

## 手动执行iptables命令配置生产环境
```
iptables -F
iptables -nL

# ssh允许
iptables -A INPUT -p tcp --dport 5123 -s 10.0.0.0/24 -j ACCEPT
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# 链默认行为
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

# 办公室行为
iptables -A INPUT -s 192.168.1.1/24 -p all -j ACCEPT
iptables -A INPUT -s 10.0.0.0/24 -p all -j ACCEPT

# 应用
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p icmp -m icmp --icmp-type any -j ACCEPT

# 允许关联包
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
```

## 保存防火墙
```
/etc/init.d/iptables save

cat /etc/sysconfig/iptables

iptables-save > /etc/sysconfig/iptables
```

## iptables有四种状态
NEW，ESTABLISHED，RELATED，INVALID。

- NEW状态：主机连接目标主机，在目标主机上看到的第一个想要连接的包
- ESTABLISHED状态：主机已与目标主机进行通信，判断标准只要目标主机回应了第一个包，就进入该状态。
- RELATED状态：主机已与目标主机进行通信，目标主机发起新的链接方式，例如ftp
- INVALID状态：无效的封包，例如数据破损的封包状态

## iptables -m, -p 参数说明
 

```
-m： module_name

-p：protocol


iptables -p tcp : 表示使用 TCP协议
iptables -m tcp：表示使用TCP模块的扩展功能（tcp扩展模块提供了 --dport, --tcp-flags, --sync等功能）

```
eg:
```
-A INPUT -p tcp -m state --state NEW -m tcp --dport 20022 -j ACCEPT
（表示：允许其他机器访问本机的 TCP端口 20022）

只允许192.168.1.1-192.168.1.3网段中的IP访问容器（需要借助于iprange模块）
iptables -A DOCKER-USER -m iprange -i docker0 ! --src-range 192.168.1.1-192.168.1.3 -j DROP
```







