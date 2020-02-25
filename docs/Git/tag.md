## tag
### 新建一个tag

```
git tag v1.0				    # 打1.0简单标签
git tag -a v0.1 -m 'first version v0.1'     # -a tag名称 -m message
git tag -a v2.2 9fceb02                     # 在9fceb02处打上tag
```

### 推tag至远程

```
git push origin v1.5                        # 推送一个tag
git push origin --tags                      # 推送所有tag
```

### 拉取tag

```
git pull			 	# 分支和tag都拉取
git fetch origin tag v4.0		# 只取v4.0tag
```

### 删除本地tag

```
git tag -d v0.1
```

### 删除远程tag

远程tag删除后, 本地用户无法直接感知, pull无法感知.

```
git push origin -d tag v0.1

git push origin :refs/tags/v20190514
```

### 查看tag信息

```
(new_cr) ➜  cr git:(develop) ✗ git show v2.0
tag v2.0
Tagger: Tang Haijun <thj8@163.com>
Date:   Thu Aug 15 10:30:31 2019 +0800

first version 2.0 for 2019-08-14

commit dc5a2abed647f2dfb6d988224e14802582d88655 (HEAD -> develop, tag: v2.0, origin/develop, origin/HEAD)
Merge: ae9e746 d8498be
Author: ttt <ttt@163.com>
Date:   Wed Aug 14 11:54:16 2019 +0800

    Merge branch 'develop_xxx' into 'develop'

```

```
$ git checkout -b version2 v2.0.0
Switched to a new branch 'version2'
```

### show

```
➜  test git:(master) git show-ref --tags --dereference
b19e9c4d887666a3c34646f6220f2d91b757a238 refs/tags/v2.0
dabb40d2e30dc939bf5d77dc29d5ee76fbc653bc refs/tags/v2.0^{}
dabb40d2e30dc939bf5d77dc29d5ee76fbc653bc refs/tags/v2.1
➜  test git:(master) git show-ref --tags
b19e9c4d887666a3c34646f6220f2d91b757a238 refs/tags/v2.0
dabb40d2e30dc939bf5d77dc29d5ee76fbc653bc refs/tags/v2.1
```

### ls-remote 

```
➜  test git:(master) git ls-remote --tags origin
b19e9c4d887666a3c34646f6220f2d91b757a238        refs/tags/v2.0
dabb40d2e30dc939bf5d77dc29d5ee76fbc653bc        refs/tags/v2.0^{}
dabb40d2e30dc939bf5d77dc29d5ee76fbc653bc        refs/tags/v2.1
```
