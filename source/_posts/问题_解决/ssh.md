---
title: Bad owner or permissions on .ssh/config Windows 10
date: 
tags: ssh
categories: 远程开发操作
top: false
---

最近想尝试在vscode中用remote ssh插件尝试远程开发，可是几次没有成功，在cmd里面输入`ssh xx@ip`，提示了 `Bad owner or permissions on .ssh/config` 这个报错，就是如图中的问题:

![image-20210408193114481](https://cdn.jsdelivr.net/gh/Miller-em/IMAGS/img/20210408193114.png)



## 解决方法

1. 找到.ssh文件夹。它通常位于C:\Users\，例如C:\Users\xxxx。
2. 右键单击.ssh文件夹，然后单击“属性”。
3. 找到并点击“安全”标签。
<!-- more -->
4. 然后单击“高级”。
5. 单击“禁用继承”，单击“确定”。
6. 将出现警告弹出窗口。单击“从此对象中删除所有继承的权限”。
7. 你会注意到所有用户都将被删除。让我们添加所有者。在同一窗口中，单击“编辑”按钮。
8. 接下来，单击“添加”以显示“选择用户或组”窗口。
9.  单击“高级”，然后单击“立即查找”按钮。应显示用户结果列表。
10. 选择您的用户帐户。
11. 然后单击“确定”（大约三次）以关闭所有窗口。



完成所有操作后，再次关闭并打开cmd应用程序并尝试连接到远程SSH主机。现在这个问题应该解决了，同时在vscode也就可以成功连接了。

