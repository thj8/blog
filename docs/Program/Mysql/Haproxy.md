
# Haproxy

## 准备工作, 配置文件
```
mkdir /data/haproxy
cd /data/haproxy

cat <<"EOF" > ./haproxy.cfg
global
    log 127.0.0.1 local2
    maxconn 4000
    daemon

defaults
    mode http
    log global
    option httplog
    option dontlognull
    option http-server-close
    option forwardfor except 127.0.0.0/8
    option redispatch
    retries 3
    timeout http-request 10s
    timeout queue 1m
    timeout connect 10s
    timeout client 1m
    timeout server 1m
    timeout http-keep-alive 10s
    timeout check 10s
    maxconn 3000

listen admin_stats
    bind 0.0.0.0:4001
    mode http
    stats uri /dbs
    stats realm Global\ statistics
    stats auth admin:admin123

listen proxy-mysql
    bind 0.0.0.0:4002
    mode tcp
    balance roundrobin
    option tcplog
    server pxc_node1 172.30.0.2:3306 check port 3306 maxconn 2000
    server pxc_node2 172.30.0.3:3306 check port 3306 maxconn 2000
    server pxc_node3 172.30.0.4:3306 check port 3306 maxconn 2000
EOF


```

## 创建并启动
```
docker create --name haproxy --net host -v /data/haproxy/:/usr/local/etc/haproxy haproxy
docker start haproxy
```

## 验证proxy是否成功
```
[root@tinyFat haproxy]# mysql -uroot -proot -h127.0.0.1 -P4002
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MySQL connection id is 8
Server version: 5.7.32-35-57 Percona XtraDB Cluster (GPL), Release rel35, Revision 2055835, WSREP version 31.47, wsrep_31.47

Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MySQL [(none)]>
```
