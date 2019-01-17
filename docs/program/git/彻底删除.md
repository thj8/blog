前两天不小心上传了一个大的文件夹，几百兆左右，后来发现没有必要放到git 上，然后再本地删除后重新提交了一版，但是后来发现 重新clone的source文件大小依然是几百兆，跟原来没有变化。。。

后才经过查阅资料才知道，原来文件一直存在于git仓库中，便于你的恢复，，，，普通的删除并不能真的将文件从仓库中移除。。

想要彻底的删除文件或文件夹需要使用以下命令：

```
$ git filter-branch --force --index-filter 'git rm --cached -r --ignore-unmatch app' --prune-empty --tag-name-filter cat -- --all
$ git for-each-ref --format='delete %(refname)' refs/original | git update-ref --stdin
$ git reflog expire --expire=now --all
$ git gc --prune=now
```
上面的app是一个文件夹，如果是文件 将命令中的 -r 去掉就可以

使用下面命令 查看项目大小：

```
$ du -hs
```

最后推送到远程的分支上：

```
$ git push --force --verbose --dry-run
$ git push --force
```
