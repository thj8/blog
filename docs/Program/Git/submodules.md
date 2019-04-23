## 添加子模块

```
➜  cr git:(develop) ✗ git submodule add git@10.10.50.215:CR/cc.git ./sv_cloud             
Cloning into '/Users/sugar/src/cr/cr/sv_cloud'...
remote: Enumerating objects: 3, done.
remote: Counting objects: 100% (3/3), done.
remote: Compressing objects: 100% (2/2), done.
remote: Total 3 (delta 0), reused 0 (delta 0)
Receiving objects: 100% (3/3), done.
```
此时运行`git status`, 你会注意到几件事情：

```
➜  cr git:(develop) ✗ git status                                                          
On branch develop
Your branch is up to date with 'origin/develop'.

Changes to be committed:
  (use "git reset HEAD <file>..." to unstage)

	modified:   .gitmodules
	new file:   sv_cloud

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working directory)

	modified:   sv_base (new commits)
```
.gitmodules中，保存了项目url与已经拉取到本地目录之间的映射：

```
➜  cr git:(develop) ✗ cat .gitmodules                                                     
[submodule "sv_base"]
	path = sv_base
	url = git@10.10.50.215:CR/cb.git
[submodule "sv_cloud"]
	path = sv_cloud
	url = git@10.10.50.215:CR/cc.git
```

```
➜  cr git:(develop) ✗ git commit -am "add submodule sv_cloud"                             
[develop c0f1ec5] add submodule sv_cloud
 3 files changed, 5 insertions(+), 1 deletion(-)
 create mode 160000 sv_cloud
```
注意sv_cloud记录的160000模式，这是git中的一种特殊模式，它本质上意为着你是将一次提交作为一项目录记录的，而非将它记录成一个子目录或者一个文件。

## 克隆有子模块的项目

```
➜  /tmp git clone git@10.10.50.215:CR/cr.git                                               
Cloning into 'cr'...
remote: Enumerating objects: 23, done.
remote: Counting objects: 100% (23/23), done.
remote: Compressing objects: 100% (16/16), done.
remote: Total 23 (delta 6), reused 19 (delta 5)
Receiving objects: 100% (23/23), done.
Resolving deltas: 100% (6/6), done.
➜  /tmp cd cr                                                                             
➜  cr git:(master) git checkout develop                                                   
Branch 'develop' set up to track remote branch 'develop' from 'origin'.
Switched to a new branch 'develop'
➜  cr git:(develop) git submodule init                                                    
Submodule 'sv_base' (git@10.10.50.215:CR/cb.git) registered for path 'sv_base'
Submodule 'sv_cloud' (git@10.10.50.215:CR/cc.git) registered for path 'sv_cloud'
➜  cr git:(develop) git submodule update                                                  
Cloning into '/private/tmp/cr/sv_base'...
Cloning into '/private/tmp/cr/sv_cloud'...
Submodule path 'sv_base': checked out '87014ad570cf5733f1b7e806b1b7c2ee9ea94476'
Submodule path 'sv_cloud': checked out 'a0c29e7f70428b93e60fd35b828e8c21670dcbfc'
➜  cr git:(develop) ls sv_base                                                            
README.md
➜  cr git:(develop) ls sv_cloud                                                           
README.md
➜  cr git:(develop)                                                                       
```
