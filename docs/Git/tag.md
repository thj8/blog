## tag
### 新建一个tag

```
git tag -a v0.1 -m 'first version v0.1'     # -a tag名称 -m message
git tag -a v2.2 9fceb02                     # 在9fceb02处打上tag
```

### 推tag指远程

```
git push origin v1.5                        # 推送一个tag
git push origin --tags                      # 推送所有tag
```

### 删除本地tag

```
git tag -d v0.1
```

### 删除远程tag

```
git push origin -d tag v0.1
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

### check分支
```
git checkout 2.0.0
```

```
$ git checkout -b version2 v2.0.0
Switched to a new branch 'version2'
```
