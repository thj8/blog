
## 配置
### core.pager
core.pager指定 Git 运行诸如log、diff等所使用的分页器，你能设置成用**more**或者任何你喜欢的分页器（默认用的是less）， 当然你也可以什么都不用，设置空字符串：

```
$ git config --global core.pager ''
```

## 暂存区

### 暂存区和HEAD比较
```
git diff --cached
```

### 工作区和暂存区区
```
git diff                    # 所有文件的差别
git diff -- readme.md       # 只看一个文件的差别
git diff -- a.md b.md       # 只看若干文件的差别
```

### 恢复暂存区和HEAD一样
```
git reset HEAD -- <file>...
```

### 恢复工作区和暂存区一样
```
git checkout -- <file>...
```

## commit

### 修改最后一次commit信息
```
git commit --amend  #amend本身就是修正的意思
```

### 修改老旧commit的message
```
git log -3
git rebase -i 27abcd123
```
此处选择reword，使用这个commit, 但是编辑commit的信息，改pick为reword，保存退出，新的窗口改写message即可

(pick 使用这个commit)
```
# p, pick <commit> = use commit
# r, reword <commit> = use commit, but edit the commit message
```

### 合并连续多次commit
```
git rebase -i 27abcd123
```
基于多次commit第一次的parent的提交hash，保留第一个pick，现在要合并的全部改为squash

(此处选择squash, 使用这个commit， 但是合并到之前到commit中)
```
# s, squash <commit> = use commit, but meld into previous commit
```

### 合并非连续多次commit
选择多次commit的第一次的parent的提交hash，移动后面非连续的commit到第一行下面，并全部改为squash

### 消除最近几次的commit
```
git reset --hard <hash>
```
工作区和暂存区都恢复了，所以此条命令**慎用**

### 不同commit制定文件的差异
```
git diff temp master -- readme.md
git diff commti1 commit2 -- readme.md
```

## 文件操作
### 正确删除文件
```
git rm name1
```

### 重命名
```
git mv name1 name2
```

## 远程仓库

### 添加远程仓库
```
git remote add origin git@github.com:thj8/blog.git
```

### 抓取和推送
```
git fetch origin
git push -u origin master
```


## 协作

### 不同人修改不同文件
git pull = git fetch + git merge
```
git pull
git commit -am "some"
git push
```

### 不同人修改相同文件不同区域
同上，没有什么要特别注意的事项

### 不同人修改相同文件相同区域
会出现冲突，解决冲突，并add，commit，push
```
git pull
vim readme.md
git commit -am"resolve conflict"
git push
```
```
git merge --abort  #取消merge
```

### 同时改变了文件名和内容 
git会智能的感知文件名的变化，不需要特殊的处理

### 把同一文件修改为不同的文件名
```
git rm index.htm
git add index1.htm
git rm index2.htm
git commit -m "resolve file name conflict"
```

## 分支

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

## tag
### 新建一个tag
```
git tag -a v0.1 -m 'first version v0.1'
```

### 推tag指远程
```
git push origin --tags
```

### 删除本地tag
```
git tag -d v0.1
```

### 删除远程tag
```
git push origin -d tag v0.1
```

## 其他
### 紧急任务来了
```
git stash
git stash list

git stash pop               # 弹出stash
git stash apply             # 恢复到工作区，但是不弹出stash
```

### 慎重使用的命令
```
git rest --hard
git checkout
```

### 禁止使用的命令
```
git push -f
```
