## 简介
**Linux Namespace**是Linux提供的一种内核级别环境隔离的方法。不知道你是否还记得很早以前的Unix有一个叫**chroot**的系统调用（通过修改根目录把用户jail到一个特定目录下），chroot提供了一种简单的隔离模式：chroot内部的文件系统无法访问外部的内容。Linux Namespace在此基础上，提供了对UTS、IPC、mount、PID、network、User等的隔离机制。


> 举个例子，我们都知道，Linux下的超级父亲进程的PID是1，所以，同chroot一样，如果我们可以把用户的进程空间jail到某个进程分支下，并像chroot那样让其下面的进程 看到的那个超级父进程的PID为1，于是就可以达到资源隔离的效果了（不同的PID namespace中的进程无法看到彼此）

## UTS Namespace
UTS Namespace主要是用来隔离**nodename**和**domainname**两个系统标识。在UTS Namespace里面啊, **每个Namespace允许有自己的hostname**。

```
package main

import  (

  "os/exec"
  "syscall"
  "os"
  "log"
)

func main() {
  cmd := exec.Command("sh")
  cmd.SysProcAttr = &syscall.SysProcAttr{
    Cloneflags: syscall.CLONE_NEWUTS,
  }

  cmd.Stdin = os.Stdin
  cmd.Stdout = os.Stdout
  cmd.Stderr = os.Stderr

  if err := cmd.Run(); err != nil {
    log.Fatal(err)
  }
}
```

- 由于UTS Namespace对hostname做了隔离，所以在这个环境内修改hostname应该不影响外部主机。

```
➜  src git:(master) ✗ sudo go run main.go
# hostname
sugar
# hostname -b thj
# hostname
thj
#
```

- 另外启动一个shell，在宿主机上运行hostname，看一下效果。

```
➜  Docker git:(master) ✗ hostname
sugar

```

> 可以看到，外部的hostname并没有被内部的修改所影响，由此可了解UTS Namespace的作用。

## IPC Namespace
IPC Namespace用来隔离**System V IPC**和**POSIX message queues**。每一个IPC Namespace都有自己的System V IPC和POSIX message queue。

```
package main

import  (

  "os/exec"
  "syscall"
  "os"
  "log"
)

func main() {
  cmd := exec.Command("sh")
  cmd.SysProcAttr = &syscall.SysProcAttr{
    Cloneflags: syscall.CLONE_NEWUTS | syscall.CLONE_NEWIPC,
  }

  cmd.Stdin = os.Stdin
  cmd.Stdout = os.Stdout
  cmd.Stderr = os.Stderr

  if err := cmd.Run(); err != nil {
    log.Fatal(err)
  }
}
```
- 可以看到，仅仅增加了syscall.CLONE_NEWIPC代表我们希望创建IPC Namespace。下面来演示隔离的效果。

```
# 查看现有的ipc messages queues
➜  Docker git:(master) ✗ ipcs -q

------ Message Queues --------
key        msqid      owner      perms      used-bytes   messages

# 创建一个message queue
➜  Docker git:(master) ✗ ipcmk -Q
Message queue id: 0
➜  Docker git:(master) ✗ ipcs -q

# 然后在看一下
------ Message Queues --------
key        msqid      owner      perms      used-bytes   messages
0x1577fa35 0          sugar      644        0            0

```

- 这里能够发现我们可以看到一个queue了。下面使用另外一个shell去运行程序。

```
# ipcs -q

------ Message Queues --------
key        msqid      owner      perms      used-bytes   messages
0x1577fa35 0          sugar      644        0            0

#
```

> 通过以上实验，可以发现，在新创建的Namespace里，看不到宿主机上已经创建的message queue，说明IIPC Namespace创建成功，IPC已经被隔离。

## PID Namespace
PID Namespace是用来隔离进程ID的。同样一个进程在不同的PID Namespace里可以拥有不同的PID。这样就可以理解。

> 在docker container里面，使用ps -ef经常会发现，在容器内，前台运行的那个进程PID是1,但是在容器外，使用ps -ef会发现同样的进程却有不同的PID。

```
package main

import  (

  "os/exec"
  "syscall"
  "os"
  "log"
)

func main() {
  cmd := exec.Command("sh")
  cmd.SysProcAttr = &syscall.SysProcAttr{
    Cloneflags: syscall.CLONE_NEWUTS | syscall.CLONE_NEWIPC | 
      syscall.CLONE_NEWPID,
  }

  cmd.Stdin = os.Stdin
  cmd.Stdout = os.Stdout
  cmd.Stderr = os.Stderr

  if err := cmd.Run(); err != nil {
    log.Fatal(err)
  }
}
```

```
➜  src git:(master) ✗ sudo go run main.go
# echo $$
1
#
```
> 可以看到，该操作打印了当前Namespace的PID，其值为1。也就是说，pid被映射到Namespace里后PID为1，。**这里还不能用ps来查看，因为ps和top等命令会使用/proc内容。**
