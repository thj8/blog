
## log
### 查看log
以下很多参数是可以叠加使用，达到最大的效果

```
git log                     # 显示所有log
git log --sumry             # 显示提交日志，并且有简要信息      (显示增加,删除的添加的文件)
git log -5                  # 显示最新的5条记录
git log -p -1               # -p 显示详细的差异
git log -2 --stat           # 仅仅显示修改过的文件
git log -2 --shortstat      # 仅仅多少个文件修改
git log -2 --name-only      # 仅显示每一次提交的文件名
git log --pretty=oneline    # 每个提交一行，hash + message
git log --since=2.weeks     # 2个星期以内的变化
git log --author=shixiaobo  # 指定作者的提交
git log -Sxxxxxxxxxxxxxxxx  # -S，可以列出那些添加或移除了某些字符串的提交
git log --no-merges         # 去除merge的日志
```
