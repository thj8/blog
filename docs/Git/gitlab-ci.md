## install runner 安装gitlab-runner

* Simply download one of the binaries for your system:

下载gitlab-runer运行二进制程序

```
 # Linux x86-64
 sudo curl -L --output /usr/local/bin/gitlab-runner https://gitlab-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-runner-linux-amd64

 # Linux x86
 sudo curl -L --output /usr/local/bin/gitlab-runner https://gitlab-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-runner-linux-386

 # Linux arm
 sudo curl -L --output /usr/local/bin/gitlab-runner https://gitlab-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-runner-linux-arm
```

You can download a binary for every available version as described in Bleeding Edge - download any other tagged release.

* Give it permissions to execute:
设置可执行权限

```
 sudo chmod +x /usr/local/bin/gitlab-runner
```

* Optionally, if you want to use Docker, install Docker with:
如果需要docker的话，还需要额外安装docker，（还可以用阿里云的yum源去安装）

```
 curl -sSL https://get.docker.com/ | sh
```

* Create a GitLab CI user:
创建gitlab运行用户，不建议直接使用root
```
 sudo useradd --comment 'GitLab Runner' --create-home gitlab-runner --shell /bin/bash
```

* Install and run as service:
安装，启动gitlab-runner, 指定运行文件目录和运行用户

```
 sudo gitlab-runner install --user=gitlab-runner --working-directory=/home/gitlab-runner
 sudo gitlab-runner start
```

* Register the Runner
注册Runner

* Add gitlab-runner user to docker group:
 添加gitlab-runner至docker组里面

```
sudo usermod -aG docker gitlab-runner
```

* Verify that gitlab-runner has access to Docker:
 验证gitlab-runner是否有docker权限

```
sudo -u gitlab-runner -H docker info
```

