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

![image-20210331194048904](https://cdn.jsdelivr.net/gh/Miller-em/IMAGS/img/20210331194049.png)



## Button

按键也是控件里面重要性占比最大的，这里就介绍一下Button控件该如何使用。首先还是介绍一下常用的几个方法：

**StateListDrawable**

StateListDrawable是Drawable资源的一种，可以根据不同的状态，设置不同的图片效果，关键节点< selector >，我们只需要将Button的 background属性设置为该drawable资源即可轻松实现，按下按钮时不同的按钮颜色或背景。

> - drawable：引用的Drawable位图
> - state_focused：是否获取焦点
> - state_pressed：控件是否被按下
> - state_enabled：控件是否可用
> - state_selected：控件是否被选择，针对有滚轮的情况
> - state_checked：控件是否被勾选
> - state_checkable：控件可否被勾选，eg:checkbox



**Button事件处理**

- 点击事件
- 长按事件
- 触摸事件



使用效果如下：

![image-20210331215525650](https://cdn.jsdelivr.net/gh/Miller-em/IMAGS/img/20210331215525.png)

其中的`backgroud`和`backgroundTink` 里面的值，分别是在drawable文件夹下面创建的selector，和在color文件夹下面的selector。

![image-20210331220029489](https://cdn.jsdelivr.net/gh/Miller-em/IMAGS/img/20210331220029.png)



对于按键事件的触发，是在`MainActivity.java`里面添加，下面就是MainActivity的代码示例：

```java
package com.example.mybutton;

import androidx.appcompat.app.AppCompatActivity;

import android.os.Bundle;
import android.util.Log;
import android.view.MotionEvent;
import android.view.View;

public class MainActivity extends AppCompatActivity {

    private static final String TAG = "Miller";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        View btn = findViewById(R.id.btn);

        //点击事件
        btn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Log.e(TAG, "onClick: ");
            }
        });

        //长按事件
        btn.setOnLongClickListener(new View.OnLongClickListener() {
            @Override
            public boolean onLongClick(View v) {
                Log.e(TAG, "onLongClick: ");
                return false;
            }
        });

        //触摸事件
        btn.setOnTouchListener(new View.OnTouchListener() {
            @Override
            public boolean onTouch(View v, MotionEvent event) {
                Log.e(TAG, "onTouch: ");
                return false;
            }
        });
    }
}
```



## EditText

这是一个文本的输入框，也是一个必须掌握的控件。先介绍常用的方法：

- android:hint   输入提示
- android:textColorHint  输入提示文字的颜色
- android:inputType  输入类型
- android:drawableXxxx  在输入框的指定方向添加图片
- android:drawablePaddling  设置图片与输入内容的间距
- android:paddingXxxx  设置内容与边框的间距
- android:background  背景色



在Android Studio里面的使用的如下：

![image-20210401163542564](https://cdn.jsdelivr.net/gh/Miller-em/IMAGS/img/20210401163542.png)



## ImageView

这是一个显示图片的控件，有时候我们需要用图片填充我们的界面，所以还是要学习一下的，他的常用方法如下：

- android:src 设置图片资源                                     
- android:scaleType 设置图片缩放类型
- android:maxHeight 最大高度
- android:maxWidth 最大宽度
- android:adjustViewBounds 调整View的界限

值得注意的是还有图片的缩放类型：

- fitStart  保持宽高比缩放图片，直到较长的边与Image的边长相等，缩放完成后将图片放在ImageView的左上角
- fitEnd  同上，缩放后放于右下角
4. fitXY  对图像的横纵方向进行独立缩放，使得该图片完全适应lmageView，但是图片的宽高比可能会发生改变
4. center 保持原图的大小，显示在lmageView的中心。当原图的size大于lmageVview的size，超过部分裁剪处理。
4. centerCrop 保持宽高比缩放图片，直到完全覆盖lmageView，可能会出现图片的显示不完全
7. centerInside  保持宽高比缩放图片，直到ImageView能够完全地显示图片
8. matrix 不改变原图的大小，从lmageView的左上角开始绘制原图，原图超过lmageVview的部分作裁剪处理

实验示例：

![image-20210401194646607](https://cdn.jsdelivr.net/gh/Miller-em/IMAGS/img/20210401194646.png)



## ProgressBar

这是一个进度条的控件，常用的方法如下：

- android:max: 进度条的最大值

- android:progress: 进度条已完成进度值

- android:indeterminate: 如果设置成true,则进度条不精确显示进度

- style="?android:attr/progressBarStyleHorizontal" 水平进度条

实践示例：

![image-20210401203614181](https://cdn.jsdelivr.net/gh/Miller-em/IMAGS/img/20210401203614.png)

效果：

<img src="https://cdn.jsdelivr.net/gh/Miller-em/IMAGS/img/20210401203650.png" alt="image-20210401203650421" style="zoom:25%;" />



## Notification

这里介绍一下，通知的使用。要想使用通知组件，需要创建两个对象，一个是NotificationManager，一个是Notification。

- 创建一个NotificationManager
  NotificationManager类是一个**通知管理器类**， 这个对象是由系统维护的服务，是以单例模式的方式获得，所以一般并不直接实例化这个对象。在Activity中， 可以使用`Activity.getSystemService(String)`方法获取**NotificationManager**对象，Activity.getSystemService(String)方法可以通过Android系统级服务的句柄，返回对应的对象。在这里需要返回NotificationManager,所以直接传递Context.NOTIFICATION SERVICE即可 。
- 使用**Bilder**构造器来创建Notification对象
  使用NotificationCompat类的Builder构造器来创建Notification对象，可以保证程序在所有的版本上都能正常工作。Android8.0新增了通知渠道这个概念，如果没有设置，则通知无法在Android8.0的机器上显示



![image-20210511115839246](https://cdn.jsdelivr.net/gh/Miller-em/IMAGS/img/20210511115848.png)

![image-20210511120006500](https://cdn.jsdelivr.net/gh/Miller-em/IMAGS/img/20210511120006.png)



## ToolBar

常用属性：

- android:layout_width="match_parent"
- android:layout_height="?attr/actionBarSize"
- android:background="#ffff00"
- app:navigationlcon="@drawable/ic_baseline_arrow_back_24"
- app:title="主标题"
- app:titleTextColor="#ff0000"
- app:titleMarginStart="90dp"
- app:subtitle="子标题"
- app:subtitleTextColor="#OOffff
- app:logo="@mipmap/ic_launcher"

![image-20210511123726114](https://cdn.jsdelivr.net/gh/Miller-em/IMAGS/img/20210511123732.png)

![image-20210511123851372](https://cdn.jsdelivr.net/gh/Miller-em/IMAGS/img/20210511123852.png)

## AlertDialog

实现方式：

- AlertDialog.Builder builder = new AlertDialog.Builder(context);构建Dialog的各种参数
- Builder.setlcon(int iconld);添加ICON
- Builder.setTitle(CharSequence title);添加标题
- Builder.setMessage(CharSequence message);添加消息
- Builder.setView(View view);设置自定义布局
- Builder.create();到建Dialog
- Builder.show();显示对话框
- setPositiveButton确定按钮
- setNegativeButton取消按钮
- setNeutralButton中间按钮

![image-20210511133254734](https://cdn.jsdelivr.net/gh/Miller-em/IMAGS/img/20210511133254.png)

![image-20210511133327903](https://cdn.jsdelivr.net/gh/Miller-em/IMAGS/img/20210511133328.png)

## PopupWindow

常用方法：

1. setContentView(View contentView)：设置PopupWindow显示的View
2. showAsDropDown(View anchor)：相对某个控件的位置(正左下方)，无偏移
3. showAsDropDown(View anchor, int xoff, int yoff)：相对某个控件的位置，有偏移
4. setFocusable(boolean focusable)：设置是否获取焦点
5. setBackgroundDravIable(Drawable background)：设置背景
6. dismiss() ：关闭弹窗
7. setAnimationStyle(int animationStyle)：设置加载动画
8. setTouchable(boolean touchable)：设置触摸使能
9. setOutsideTouchable(boolean touchable)：设置PopupWindow外面的触摸使能



![image-20210511141847626](https://cdn.jsdelivr.net/gh/Miller-em/IMAGS/img/20210511141848.png)

![image-20210511141906380](https://cdn.jsdelivr.net/gh/Miller-em/IMAGS/img/20210511141906.png)

![image-20210511141923657](https://cdn.jsdelivr.net/gh/Miller-em/IMAGS/img/20210511141924.png)