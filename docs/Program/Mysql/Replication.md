# Replication

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

