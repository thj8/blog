## 简介
**Linux Namespace**是Linux提供的一种内核级别环境隔离的方法。不知道你是否还记得很早以前的Unix有一个叫**chroot**的系统调用（通过修改根目录把用户jail到一个特定目录下），chroot提供了一种简单的隔离模式：chroot内部的文件系统无法访问外部的内容。Linux Namespace在此基础上，提供了对UTS、IPC、mount、PID、network、User等的隔离机制。


> 举个例子，我们都知道，Linux下的超级父亲进程的PID是1，所以，同chroot一样，如果我们可以把用户的进程空间jail到某个进程分支下，并像chroot那样让其下面的进程 看到的那个超级父进程的PID为1，于是就可以达到资源隔离的效果了（不同的PID namespace中的进程无法看到彼此）


## clone系统调用

```
#define _GUN_SOURCE
#include <sys/types.h>
#include <sys/wait.h>
#include <stdio.h>
#include <sched.h>
#include <signal.h>
#include <unistd.h>

#define STACK_SIZE (1024*1024)
static char container_stack[STACK_SIZE];		

char* const container_args[] = {
  "bin/bash",
  NULL
};

int container_main(void* arg)
{
  printf("Container - inside the container!\n");
  execv(container_args[0], container_args);
  printf("Something's wrong!");
}

int main()
{
  printf("Parent - start a container!\n");
  int container_pid = clone(container_main, STACK_SIZE+container_stack, SIGCHLD, NULL);
  waitpid(container_pid, NULL, 0);
  printf("Parent - container stopped!\n");
  return 0;
}
```
从上面的程序，我们可以看到，这和pthread基本上是一样的玩法。但是，对于上面的程序，父子进程的进程空间是没有什么差别的，父进程能访问到的子进程也能。



