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

# replication

## 准备工作(主库)
```
mkdir /data/mysql/master01 -p
cd /data/mysql/master01/
mkdir conf data
chmod 777 * -R

cat <<"EOF" > conf/my.cnf
[mysqld]
log-bin=mysql-bin                       # 开启二进制日志
server-id=1                             # 服务id, 不可重复
EOF

```

## 启动容器并启动(主库)
```
docker create --name percona-master01 -v /data/mysql/master01/data:/var/lib/mysql -v /data/mysql/master01/conf:/etc/my.cof.d -p 3306:3306 -e MYSQL_ROOT_PASSWORD=root percona:5.7.23
docker start percona-master01
```

## 建立用户,并授权(主库)
```
[root@tinyFat conf]# docker exec -it 0a /bin/bash
bash-4.2$ mysql -uroot -proot
mysql: [Warning] Using a password on the command line interface can be insecure.
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 3
Server version: 5.7.23-23-log Percona Server (GPL), Release 23, Revision 500fcf5

Copyright (c) 2009-2018 Percona LLC and/or its affiliates
Copyright (c) 2000, 2018, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> create user 'cyberpeace'@'%' identified by 'cyberpeace';
Query OK, 0 rows affected (0.00 sec)

mysql> grant replication slave on *.* to 'cyberpeace'@'%';
Query OK, 0 rows affected (0.00 sec)

mysql> flush privileges;
Query OK, 0 rows affected (0.00 sec)

mysql>
```

## 查询master状态(主库)
```
[root@tinyFat conf]# docker exec -it 0a /bin/bash
bash-4.2$ mysql -uroot -proot
mysql: [Warning] Using a password on the command line interface can be insecure.
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 2
Server version: 5.7.23-23-log Percona Server (GPL), Release 23, Revision 500fcf5

Copyright (c) 2009-2018 Percona LLC and/or its affiliates
Copyright (c) 2000, 2018, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> show master status;
+------------------+----------+--------------+------------------+-------------------+
| File             | Position | Binlog_Do_DB | Binlog_Ignore_DB | Executed_Gtid_Set |
+------------------+----------+--------------+------------------+-------------------+
| mysql-bin.000001 |      956 |              |                  |                   |           # file 和 position为下面重库需要用到的内容
+------------------+----------+--------------+------------------+-------------------+
1 row in set (0.00 sec)

mysql> show global variables like 'binlog%';
+--------------------------------------------+--------------+
| Variable_name                              | Value        |
+--------------------------------------------+--------------+
| binlog_cache_size                          | 32768        |
| binlog_checksum                            | CRC32        |
| binlog_direct_non_transactional_updates    | OFF          |
| binlog_error_action                        | ABORT_SERVER |
| binlog_format                              | ROW          |
| binlog_group_commit_sync_delay             | 0            |
| binlog_group_commit_sync_no_delay_count    | 0            |
| binlog_gtid_simple_recovery                | ON           |
| binlog_max_flush_queue_time                | 0            |
| binlog_order_commits                       | ON           |
| binlog_row_image                           | FULL         |
| binlog_rows_query_log_events               | OFF          |
| binlog_space_limit                         | 0            |
| binlog_stmt_cache_size                     | 32768        |
| binlog_transaction_dependency_history_size | 25000        |
| binlog_transaction_dependency_tracking     | COMMIT_ORDER |
+--------------------------------------------+--------------+
16 rows in set (0.00 sec)

mysql> show global variables like 'server%';
+----------------+--------------------------------------+
| Variable_name  | Value                                |
+----------------+--------------------------------------+
| server_id      | 1                                    |
| server_id_bits | 32                                   |
| server_uuid    | a47234fa-55b3-11eb-8dcd-0242ac110002 |
+----------------+--------------------------------------+
3 rows in set (0.01 sec)
```

## 准备工作(重库)
```
mkdir /data/mysql/slave01 -p
cd /data/mysql/slave01/
mkdir conf data
chmod 777 * -R

cat <<"EOF" > conf/my.cnf
[mysqld]
server-id=2
EOF
```

## 创建并启动容器
```
docker create --name percona-slave01 -v /data/mysql/slave01/data:/var/lib/mysql -v /data/mysql/slave01/conf:/etc/my.cnf.d/ -p 3307:3306 -e MYSQL_ROOT_PASSWORD=root percona:5.7.23
docker start 61
```

## 配置重库slave(重库)

```
mysql> change master to
    ->     master_host='172.17.0.2',
    ->     master_user='cyberpeace',
    ->     master_password='cyberpeace',
    ->     master_port=3306,
    ->     master_log_file='mysql-bin.000001',
    ->     master_log_pos=956;
Query OK, 0 rows affected, 2 warnings (0.01 sec)

mysql> start slave;
Query OK, 0 rows affected (0.00 sec)

mysql> show slave status \G;
*************************** 1. row ***************************
               Slave_IO_State: Waiting for master to send event
                  Master_Host: 172.17.0.2
                  Master_User: cyberpeace
                  Master_Port: 3306
                Connect_Retry: 60
              Master_Log_File: mysql-bin.000001
          Read_Master_Log_Pos: 956
               Relay_Log_File: 61a0907b5fa6-relay-bin.000004
                Relay_Log_Pos: 320
        Relay_Master_Log_File: mysql-bin.000001
             Slave_IO_Running: Yes                                    # 两者为yes就表示成功
            Slave_SQL_Running: Yes                                    # 
              Replicate_Do_DB:
          Replicate_Ignore_DB:
           Replicate_Do_Table:
       Replicate_Ignore_Table:
      Replicate_Wild_Do_Table:
  Replicate_Wild_Ignore_Table:
                   Last_Errno: 0
                   Last_Error:
                 Skip_Counter: 0
          Exec_Master_Log_Pos: 956
              Relay_Log_Space: 700
              Until_Condition: None
               Until_Log_File:
                Until_Log_Pos: 0
           Master_SSL_Allowed: No
           Master_SSL_CA_File:
           Master_SSL_CA_Path:
              Master_SSL_Cert:
            Master_SSL_Cipher:
               Master_SSL_Key:
        Seconds_Behind_Master: 0
Master_SSL_Verify_Server_Cert: No
                Last_IO_Errno: 0
                Last_IO_Error:
               Last_SQL_Errno: 0
               Last_SQL_Error:
  Replicate_Ignore_Server_Ids:
             Master_Server_Id: 1
                  Master_UUID: a47234fa-55b3-11eb-8dcd-0242ac110002
             Master_Info_File: /var/lib/mysql/master.info
                    SQL_Delay: 0
          SQL_Remaining_Delay: NULL
      Slave_SQL_Running_State: Slave has read all relay log; waiting for more updates
           Master_Retry_Count: 86400
                  Master_Bind:
      Last_IO_Error_Timestamp:
     Last_SQL_Error_Timestamp:
               Master_SSL_Crl:
           Master_SSL_Crlpath:
           Retrieved_Gtid_Set:
            Executed_Gtid_Set:
                Auto_Position: 0
         Replicate_Rewrite_DB:
                 Channel_Name:
           Master_TLS_Version:
1 row in set (0.00 sec)

```

# haproxy

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