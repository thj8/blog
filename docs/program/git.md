## 数一数tree的个数

```shell
find .git/objects -type f |awk -F'/' '{print $3$4}'|xargs -I {} git cat-file -t {}
commit
tree
tree
tree
commit
blob
blob

find .git/objects -type f |awk -F'/' '{print $3$4}'|xargs -I {} git cat-file -p {}
tree 4e311ec3283274299bd0a030a58c5f38f087786f
parent 311a7a387e33ccd1673015f9efe858e6e0f76511
author tanghaijun <tanghj@cyberpeace.cn> 1545664859 +0800
committer tanghaijun <tanghj@cyberpeace.cn> 1545664859 +0800

add thj
040000 tree 6e17e26237e12bc64cad4af1d9ddd8e8969d8111	doc
100644 blob ce013625030ba8dba906f756967f9e9ca394464a	thj
100644 blob 1b98d086dfdf06f690f5bc601d46c3704ef0b4e9	thj2
100644 blob ce013625030ba8dba906f756967f9e9ca394464a	readme
040000 tree 6e17e26237e12bc64cad4af1d9ddd8e8969d8111	doc
tree 315f8050b11704358140f3f25f4ae682d631f7df
author tanghaijun <tanghj@cyberpeace.cn> 1545663852 +0800
committer tanghaijun <tanghj@cyberpeace.cn> 1545663852 +0800

add readme
hello
rrrrrr

find .git/objects -type f
.git/objects/3b/4fccb3f351c9f0f1fc05bdaa9d4df545e8a7ce
.git/objects/4e/311ec3283274299bd0a030a58c5f38f087786f
.git/objects/6e/17e26237e12bc64cad4af1d9ddd8e8969d8111
.git/objects/31/5f8050b11704358140f3f25f4ae682d631f7df
.git/objects/31/1a7a387e33ccd1673015f9efe858e6e0f76511
.git/objects/ce/013625030ba8dba906f756967f9e9ca394464a
.git/objects/1b/98d086dfdf06f690f5bc601d46c3704ef0b4e9
```

## 分离头指针

## 修改最后一次commit信息

```
git commit --amend
```
