## 分支

### 新建分支

```
git branch thj                      # 当前分支新建一个thj分支
git checkout -b develop master      # 由master分支新建develop分支，并切换至develop分支
```

### 推送至远端

```
git push origin develop:develop 
```

### 查看全部分支
包括本地和远程的所有分支

```
git branch -a
```

### 删除本地分支

```
git branch -d thj_test
git branch -D thj_test     # 强制删除分支
```

### 删除远程分支

```
git push origin -d thj_test
```

### 查看远程和本地分支对应关系

```
git remote show origin
```

### 删除远程已经删除过的分支

```
git remote prune origin
```

### 只删除远程的分支

```
git push origin -d branch_name
```
