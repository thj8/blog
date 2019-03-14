## 简介
**Linux Namespace**是Linux提供的一种内核级别环境隔离的方法。不知道你是否还记得很早以前的Unix有一个叫**chroot**的系统调用（通过修改根目录把用户jail到一个特定目录下），chroot提供了一种简单的隔离模式：chroot内部的文件系统无法访问外部的内容。Linux Namespace在此基础上，提供了对UTS、IPC、mount、PID、network、User等的隔离机制。


> 举个例子，我们都知道，Linux下的超级父亲进程的PID是1，所以，同chroot一样，如果我们可以把用户的进程空间jail到某个进程分支下，并像chroot那样让其下面的进程 看到的那个超级父进程的PID为1，于是就可以达到资源隔离的效果了（不同的PID namespace中的进程无法看到彼此）

## UTS Namespace
UTS Namespace主要是用来隔离nodename和domainname两个系统标识。在UTS Namespace利民啊，每个Namespace允许有自己的hostname。

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

由于UTS Namespace对hostname做了隔离，所以在这个环境内修改hostname应该不影响外部主机。

```
➜  src git:(master) ✗ sudo go run uts.go
# hostname
sugar
# hostname -b thj
# hostname
thj
#
```

另外启动一个shell，在宿主机上运行hostname，看一下效果。

```
➜  Docker git:(master) ✗ hostname
sugar

```
