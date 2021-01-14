# PXC

## 下载pxc镜像
```
docker pull percona/percona-xtradb-cluster:5.7
docker tag 6a pxc
```

## 创建卷
```
docker volume create v1
docker volume create v2
docker volume create v3
```

## 简历私有网络
```
docker network create --subnet=172.30.0.0/24 pxc-network
```

## 建立docker, 不启动
```
docker create -p 13306:3306 -v v1:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=root -e CLUSTER_NAME=pxc --name=pxc_node1 --net=pxc-network --ip=172.30.0.2 pxc
docker create -p 13307:3306 -v v2:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=root -e CLUSTER_NAME=pxc --name=pxc_node2 -e CLUSTER_JOIN=pxc_node1 --net=pxc-network --ip=172.30.0.3 pxc
docker create -p 13308:3306 -v v3:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=root -e CLUSTER_NAME=pxc --name=pxc_node3 -e CLUSTER_JOIN=pxc_node1 --net=pxc-network --ip=172.30.0.4 pxc
```

## 启动pxc_node1
```
docker start pxc_node1

用工具去尝试连接13306端口, 可以连接后再启动pxc_node2, pxc_node3
 
docker start pxc_node2
docker start pxc_node3
```

## 查看是否成功
```
[root@tinyFat volumes]# docker exec -it pxc_node1 /bin/bash
bash-4.4$ mysql -uroot -proot
mysql: [Warning] Using a password on the command line interface can be insecure.
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 8
Server version: 5.7.32-35-57 Percona XtraDB Cluster (GPL), Release rel35, Revision 2055835, WSREP version 31.47, wsrep_31.47

Copyright (c) 2009-2020 Percona LLC and/or its affiliates
Copyright (c) 2000, 2020, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> show status like 'wsrep_cluster%';
+--------------------------+--------------------------------------+
| Variable_name            | Value                                |
+--------------------------+--------------------------------------+
| wsrep_cluster_weight     | 3                                    |
| wsrep_cluster_conf_id    | 3                                    |     
| wsrep_cluster_size       | 3                                    |                     # 看到此处size为3就说明ok了
| wsrep_cluster_state_uuid | 368f20b0-55ab-11eb-93ad-338c3cb9b7a5 |
| wsrep_cluster_status     | Primary                              |
+--------------------------+--------------------------------------+
5 rows in set (0.00 sec)

mysql>
```

