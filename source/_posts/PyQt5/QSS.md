---
title: PyQt-利用QSS美化界面
date: 
tags: PyQt
categories: 界面设计
top: false
---



由于Pyqt（Qt在内）设计的界面很丑陋啊，不能够忍受，由于项目的需要，必须要对之前写的界面进行美化。其中就必须用到一个工具——**QSS**，QSS这东西看着网络上对它的介绍：这是一个类似于CSS语言的东西，负责对控件的美化，风格设置，**如果对CSS熟悉的人，对QSS就很好入手**。好了，我不会CSS，这不就是难为我了吗。然后，我就疯狂搜寻网络上的相关资料。果然发现用了QSS和没有用设计出来的界面有着天壤之别！

![](https://cdn.jsdelivr.net/gh/Miller-em/IMAGS/img/20210420180314.gif)



 <!-- more -->

## 从无到有

这里我将会从0开始设计一个属于我的一个自认为还行的界面，怎么也得比原始的Qt界面要好看吧 :joy: 。这个过程也记录下来，方便以后回顾。

我所用到的工具：

- Pyqt5
- Qt Designer
- VsCode
- Python

有一说一，有了**Qt Designer**的帮助，界面开发时，在设计框架上面可以进程加快很多，比一行一行代码手敲效率搞了不知道多少。当然我不是很精通这个软件，过程中会遇到一些，这些问题也会记录 :pencil:



## Qt Designer设计框架

首先第一个难点就是，**布局**，我一般都是用的栅格布局。但是当你把栅格布局把组件布局好过后，但是里面的组件就会变得不受控制。所以就有两个点，需要用在布局上面：弹簧(**Spacers)**和属性**Layout**，这两个部分一定要好好的调，不然就会很难受，这里建议就是耐心一点，慢慢试试参数。

下面是利用Qt Designer设计的界面骨架，这就是一个图形界面最初的样子 :smile: 

![image-20210422161715303](https://cdn.jsdelivr.net/gh/Miller-em/IMAGS/img/20210422161722.png)



## 利用QSS对界面进行装修

用`qt designer` 设计好的界面，选择另存为可以保存为`.ui`文件，这样的文件我们是不能够直接使用的，所以我们还需要运行命令，将`.ui`文件转化为`.py`文件：

```
pyuic5 -x xxx.ui -o xxx.py
```

这样在相同的目录下就会产生生成的GUI的py文件，你可以**python**它一下，可以得到和你设计的一样的界面。此后就可以对该py文件进行修改，对相应的组件进行**QSS**装修。

下面是我对一些组件美化的qss:

```python
self.widget.setStyleSheet('''
                                        QWidget#widget{
                                            color:#232C51;
                                            background:white;
                                            border-top:1px solid darkGray;
                                            border-bottom:1px solid darkGray;
                                            border-right:1px solid darkGray;
                                        }
                                    ''') 
self.label_4.setStyleSheet('''QLabel#label_4{
                                            border:none;
                                            font-size:25px;
                                            font-weight:700;
                                           font-family: "宋体";
                                        }''')
self.frame_2.setStyleSheet('''QFrame#frame_2{
                                            color:#232C51;
                                            background:white;
                                            border-top:1px solid darkGray;
                                            border-bottom:1px solid darkGray;
                                            border-right:1px solid darkGray;
                                            border-left:1px solid darkGray;
                                            border-top-right-radius:10px;
                                            border-bottom-right-radius:10px; 
                                            border-top-left-radius:10px;
                                            border-bottom-left-radius:10px; 
                                        }''')
...
```

大致QSS的基本设定，我就会color，background，border-xxx，这些基本的熟悉



### 设置按钮的颜色和图标

我想的是禁用了边框，因为边框的存在和我们的界面美化后显得很不一致。所以我们需要自定义关闭，最大化，最小化按钮，这里用的mac风格，分别用不同的颜色填充。修改代码为：

![image-20210422163112349](https://cdn.jsdelivr.net/gh/Miller-em/IMAGS/img/20210422163112.png)



设置图标，我们需要用到**qtawesome**这个图标库，里面有许多的常用的图标。下面是他的使用方法：

![image-20210422163529044](https://cdn.jsdelivr.net/gh/Miller-em/IMAGS/img/20210422163529.png)

选择图标就是：`qta.icon('fa.xxx', color)` ，其中的`fa.xxx`怎么选择，这里就需要打开网站：http://www.fontawesome.com.cn/faicons/ 里面有他的名字，直接填上xxx位置就好了，至于`color`, 就是设置图标颜色



## 关闭窗口，拖拽等操作

在此之前我们要设置几行代码：

```python
MainWindow.setWindowOpacity(0.95) # 设置窗口透明度
MainWindow.setWindowFlag(QtCore.Qt.FramelessWindowHint) # 隐藏边框
MainWindow.setAttribute(QtCore.Qt.WA_TranslucentBackground) # 设置窗口背景透明
```

然后重新对按钮进行信号赋值：

```python
self.pushButton_2.clicked.connect(self.close)
self.pushButton_6.clicked.connect(self.slot_max_or_recv)
self.pushButton.clicked.connect(self.showMinimized)

def slot_max_or_recv(self):
        if self.isMaximized():
            self.showNormal()
        else:
            self.showMaximized()
```

这样就完成了，那三个键的功能。



拖拽功能也是在页面类里面重写3个函数：

```python
# 重写三个方法使我们的窗口支持拖动，上面参数 window 就是拖动对象
    def mousePressEvent(self, event):  # 鼠标长按事件
        if event.button() == QtCore.Qt.LeftButton:
            self.m_drag = True
            self.m_DragPosition = event.globalPos() - self.pos()
            event.accept()
            self.setCursor(QtGui.QCursor(QtCore.Qt.OpenHandCursor))

    def mouseMoveEvent(self, QMouseEvent):  # 鼠标移动事件
        if QtCore.Qt.LeftButton and self.m_drag:
            self.move(QMouseEvent.globalPos() - self.m_DragPosition)
            QMouseEvent.accept()

    def mouseReleaseEvent(self, QMouseEvent):  # 鼠标释放事件
        self.m_drag = False
        self.setCursor(QtGui.QCursor(QtCore.Qt.ArrowCursor))
```



到此，我们的界面大致就设计好了！加上我们一个项目功能看看效果吧：

![image-20210422165946783](https://cdn.jsdelivr.net/gh/Miller-em/IMAGS/img/20210422165947.png)



## 参考链接

[PyQT5速成教程-4 Qt Designer实战[上\]]: https://www.jianshu.com/p/61cb5ed4548f

