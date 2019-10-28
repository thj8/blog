## git flow
### 初始分支
所有在Master分支上的Commit应该Tag

![](./assets/1.png)

### Feature 分支
分支名 feature/*,Feature分支做完后，必须合并回Develop分支, 合并完分支后一般会删点这个Feature分支，但是我们也可以保留

![](./assets/2.png)

### Release分支
分支名 release/*

Release分支基于Develop分支创建，打完Release分之后，我们可以在这个Release分支上测试，修改Bug等。同时，其它开发人员可以基于开发新的Feature (记住：一旦打了Release分支之后不要从Develop分支上合并新的改动到Release分支)

发布Release分支时，合并Release到Master和Develop， 同时在Master分支上打个Tag记住Release版本号，然后可以删除Release分支了。

![](./assets/3.png)

### 维护分支 Hotfix
分支名 hotfix/*

hotfix分支基于Master分支创建，开发完后需要合并回Master和Develop分支，同时在Master上打一个tag

![](./assets/4.png)

[A successful Git branching model](https://nvie.com/posts/a-successful-git-branching-model/)

[Git 在团队中的最佳实践--如何正确使用Git Flow](https://www.cnblogs.com/wish123/p/9785101.html)
