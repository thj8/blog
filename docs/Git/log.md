
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

## 查看差异

## 1.查看dev有,而master中没有的
```
git log dev ^master
```

## 2.查看dev中比master中多提交了哪些内容
```
git log maser..dev
```

## 3.不知道谁提交的多谁少,单纯指向知道有什么不一样
```
git log dev...master
```

## 5.上述条件,再显示出每个提交是哪个分支
```
git log --left-right dev...master
```


## 查看一个文件在哪个版本被删除了

比如查询vue.config.js这个文件在什么时候被删除了

```
git log --diff-filter=D --summary | grep -C 10 vue.config.js
```
