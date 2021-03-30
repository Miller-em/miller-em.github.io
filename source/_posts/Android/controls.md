---
title: Android 常用控件方法介绍-Android入门(一)
date: 
tags: Android
categories: Android
top: false
---


## 引言

任何**GUI**的设计，入门的话，一定是控件的使用。前面学过PyQt ，有一些基本的GUI的设计思想。所以对于安卓部分的话，控件还是很容易上手的。主要是需要熟悉一下Android Studio的使用方法，以及生成的工程结构。在Android Studio里面，我们想要使用一个控件的话，是直接对XML文件进行编写，所以对于基本的XML文件的书写，要熟悉XML的语法。下面我将会介绍常用的几个Android的控件。

使用控件我们是在`activity_main.xml`里面进行编辑，这个文件是在Project结构下`app/src/main/res/layout/activity_main.xml`
 <!-- more -->
## TextView

介绍控件，首先介绍方法：

> 基础属性：
>
> - layout_width：组件的宽度
> - layout_height：组件的高度
> - id：为TextView设置一个id号
> - text：设置显示的文本内容
> - textColor：设置字体颜色
> - textSize：字体大小，单位一般是用sp
> - textStyle：设置字体风格，三个可选值：normal， bold，italic
> - background：控件的背景颜色，可以理解为填充整个控件的颜色，可以是图片
> - gravity：设置控件中内容的对齐方向，TextView中是文件，ImageView中是图片
>
> 带阴影的TextView:
>
> - android:shadowColor：设置阴影颜色，需要与shadowRadius一起使用
> - android:shadowRadius：设置阴影的模糊程度，设为0.1就变成字体颜色了，建议使用3.0
> - android:shadowDx：设置阴影在水平方向的偏移，就是水平方向阴影开始的横坐标位置
> - android:shadowDy：设置阴影在竖直方向的偏移，就是竖直方向阴影开始的纵坐标位置

使用效果实例：

![image-20210330214235832](https://cdn.jsdelivr.net/gh/Miller-em/IMAGS/img/20210330214236.png)