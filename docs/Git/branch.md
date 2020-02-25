## 分支

### 新建分支

```
git branch thj                      # 当前分支新建一个thj分支
git checkout -b develop master      # 由master分支新建develop分支，并切换至develop分支
```

### 推送至远端

```
git push origin develop:develop 
git push -u origin develop
git push --set-upstream origin develop
```

### 查看全部分支
包括本地和远程的所有分支

```
git branch -a
```

### 拉取远程分支

```
git pull
git checkout -b develop origin/develop       		# 创建并关联
git pull origin develop:develop2			# 远程develop, 本地develop2

git fetch origin develop:refs/remotes/origin/develop2   # 远程develop, 本地develop2
```

### 删除本地分支

```
git branch -d thj_test
git branch -D thj_test     # 强制删除分支
```

### 删除远程分支

```
git push origin :thj_test
git push origin -d thj_test
git push origin --delete thj_test
```

### 查看远程和本地分支对应关系

```
git remote show origin
```

### 删除远程已经删除过的分支,

清理无效的追踪分支(本地的远程分支)

```
git remote prune origin
git remote prune origin --dry-run
```

