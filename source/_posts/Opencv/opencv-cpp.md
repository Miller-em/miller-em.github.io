---
title: 工程实践任务-OpenCV学习
date: 
tags: ['OpenCV']
categories: 图像处理
top: false
---



作为一个**DLer**，尤其是做计算机视觉的人来说，基本的传统的图像处理是绕不开的。说起图像处理的库，就不得不提起`OpenCV`，`OpenCV`是一个开源的图像处理库，虽然目前已经大部分的视觉问题都是利于`TF`和`Pytorch`这两大深度学习库开发的。但是在很多预处理阶段都会对图像进行预处理，比如说图像的读取，图像增强，和图像保存大部分都是会用到OpenCV，所以学习OpenCV是十分必要的，特别的其中的图像处理的算法库，还是挺重要的。同时这也是工程实践项目的基础知识储备，趁着这个机会较系统的学习这个库。

 <!-- more -->

## 阶段一、OpenCV介绍和安装

这里我选择的是C++版本的OpenCV，虽然现在很多人都是选择的Python版本的。但是现在我希望能够多接触C++，提高我的C++的写读能力，同时学好C++的OpenCV，Python版本的也是很容易上手的。但是C++版本的OpenCV在安装起来就比Python的相对麻烦一点，我用惯了VsCode，所以利用Vscode的编程环境学习OpenCV。

对于OpenCV的环境的环境搭建，我是参考的这篇教程:smile:：
https://blog.csdn.net/zhaiax672/article/details/88971248

这里提一下Python版本的OpenCV的安装方法，直接命令行输入：`pip install opencv-python`



## 阶段二、OpenCV的基本操作

### 1. OpenCV进行图像的读写

对图像的读写主要集中在两个函数：`imread()`和`imwrite()`上面，用法也相对简单。下面是这两个函数，对图片读取和保存的C++代码：

```c++
#include <iostream>
#include <opencv2/opencv.hpp>

int main(int argc, char** argv){
	cv::Mat img = cv::imread("lena.jpg", cv::IMREAD_GRAYSCALE);	//读取图片,以灰度图读入

	if (img.empty()){
		std::cout << "读取图片失败！" << std::endl;
		return -1;
	}

	cv::namedWindow("image", 1);
	cv::imshow("image", img);
	cv::waitKey(0);

	cv::imwrite("save_lena.jpg", img); //保存图像
	return 0;
}
```

### 2. OpenCV读取视频和摄像头

这一部分内容是我自己加的，老师的学习路线是没有给出的，但是对于我们之后的工程实践的项目里面这个对于视频的读取和摄像头的读取是非常必要的。视频读取，主要利用VideoCapture类下的方法打开视频并获取视频中的帧。

所以！以下给出代码：

(1). 读取视频

```c++
#include<opencv2/opencv.hpp>
#include<iostream>

int main()
{
	cv::VideoCapture cap;
	cv::Mat frame;		//定义一帧图片

	frame = cap.open("helmet_det.mp4");
	if (!cap.isOpened()){
		std::cout<<"打开视频失败！"<<std::endl;
		return -1;
	}

	cv::namedWindow("output", cv::WINDOW_AUTOSIZE);

	while (cap.read(frame)){
		cv::imshow("output", frame);
		cv::waitKey(10);
	}
	cap.release();
	return 0;
}
```

cap.open()的参数为0时为读取摄像头：

```c++
frame= cap.open(0);
```

(2). 写视频

通过获取视频，然后通过

`capture.get(CV_CAP_PROP_FRAME_WIDTH)`, `capture.get(CV_CAP_PROP_FRAME_HEIGHT)`

获取当前帧的宽度和高度，创建一个VideoWriter类对象writer进行视频的写入。写入前可进行视频的简单处理。代码如下：

```c++
#include<opencv2/opencv.hpp>
#include<iostream>

int main()
{
	cv::VideoCapture cap;
	cv::Mat frame, gray;

	frame = cap.open("helmet_det.mp4");
	if (!cap.isOpened()){
		std::cout<<"打开视频失败！"<<std::endl;
		return -1;
	}

	cv::Size size = cv::Size(cap.get(cv::CAP_PROP_FRAME_WIDTH),
							 cap.get(cv::CAP_PROP_FRAME_HEIGHT));
	cv::VideoWriter writer("helmet.mp4", cv::VideoWriter::fourcc('M', 'J', 'P', 'G'), 10, size, true);

	cv::namedWindow("output", cv::WINDOW_AUTOSIZE);

	while (cap.read(frame)){
		cv::cvtColor(frame, gray, cv::COLOR_BGR2GRAY); //转化成灰度图
		cv::threshold(gray, gray, 0, 255, cv::THRESH_BINARY | cv::THRESH_OTSU); //阈值处理
		cv::cvtColor(gray, gray, cv::COLOR_GRAY2BGR);
		writer.write(gray);
		cv::imshow("output", gray);
		cv::waitKey(10);
	}
	cv::waitKey(0);
	cap.release();
	return 0;
}
```

摄像头一样像上面处理。

### 3.OpenCV在图像上面添加文字

在图片上面添加文字也是很有必要的，有时候我们需要在图像上添加一些注释信息，比如说在视频中，我们可以利用添加文字的操作，标注视频的**FPS**信息。利用cv::putText()函数实现，具体实例如下：

```c++
#include<opencv2/opencv.hpp>

using namespace cv;

int main()
{
	const char* filename = "lena.jpg";

	cv::Mat img = cv::imread(filename, -1);
	if (img.empty()){
		std::cout << "打开图片失败" << std::endl;
		return -1;
	}

	cv::Point p = cv::Point(50, img.rows / 2 - 50);
	cv::putText(img, "I'm Lena!", p, cv::FONT_HERSHEY_TRIPLEX, 0.8, cv::Scalar(255,200,200), 2);  //在此添加文字
	cv::imshow("result", img);
	cv::imwrite("lena_text.jpg", img);
	cv::waitKey(0);
	return 0;
}
```

运行结果：

![image-20210616193724763](https://cdn.jsdelivr.net/gh/Miller-em/IMAGS/img/20210616193732.png)

### 4.OpenCV获取像素值并进行修改

难免有时候我们要对一些单个的像素点做操作，所以我们会用到`cv::Mat img.at<uchar>(row, col)`获取某个图像坐标的像素值，我们还可以重新对他复制，下面就是我读取一张图片，并且把每个像素点都**取反**，实例如下：

```c++
#include <iostream>
#include <opencv2/opencv.hpp>

int main(int argc, char** argv){
	int height, width;
	cv::Mat img = cv::imread("lena.jpg", cv::IMREAD_GRAYSCALE);	//读取图片,以灰度图读入

	if (img.empty()){
		std::cout << "读取图片失败！" << std::endl;
		return -1;
	}
	height = img.rows;
	width = img.cols;

	for (int row=0; row < height; ++row){
		for (int col=0; col <width; ++col){
			int gray = img.at<uchar>(row, col);
			img.at<uchar>(row, col) = 255 - gray;
		}
	}

	cv::namedWindow("image", 1);
	cv::imshow("image", img);
	cv::waitKey(0);

	cv::imwrite("save_lena.jpg", img);
	return 0;
}
```

运行结果：

![image-20210616203239878](https://cdn.jsdelivr.net/gh/Miller-em/IMAGS/img/20210616203240.png)



## 阶段三、OpenCV的图像处理方法

### 1.OpenCV进行几何变换

常见的图像的几何变换有：移动，旋转，扩展缩放，仿射变换的等；

#### 扩展缩放

扩展缩放只是改变图像的尺寸大小，OpenCV提供了`cv::resize`方法实现。图像的尺寸可以自己设置，可以指定缩放因子或者不同的插值方式。具体实例如下：

```c++
#include <iostream>
#include <opencv2/opencv.hpp>

int main(int argc, char** argv){
	cv::Mat img = cv::imread("lena.jpg", cv::IMREAD_GRAYSCALE);	//读取图片,以灰度图读入

	if (img.empty()){
		std::cout << "读取图片失败！" << std::endl;
		return -1;
	}

	cv::Mat outimg;
	cv::resize(img, outimg, cv::Size(img.rows * 0.75, img.cols * 0.75), 0, 0, cv::INTER_LINEAR); //将图片缩放到75%
	cv::imshow("origin image", img);
	cv::imshow("out image", outimg);
	cv::waitKey(0);
	return 0;
}
```

运行结果：

![image-20210617185156360](https://cdn.jsdelivr.net/gh/Miller-em/IMAGS/img/20210617185156.png)

#### 平移

平移就是将对象换一个位置。图像的平移分为两步：首先定义好图像的平移矩阵，分别指定x方向和y方向上的平移量tx和ty，平移矩阵的形式如下：
$$
M=\left[\begin{array}{lll}
1 & 0 & \mathrm{t}_{\mathrm{x}} \\
0 & 1 & \mathrm{t}_{y}
\end{array}\right]
$$
具体实例：

```c++
#include <iostream>
#include <opencv2/opencv.hpp>

int main(int argc, char** argv){
	cv::Mat img = cv::imread("lena.jpg");	//读取图片,以灰度图读入
	cv::Mat outimg;

	if (img.empty()){
		std::cout << "读取图片失败！" << std::endl;
		return -1;
	}

	//定义平移矩阵
	cv::Mat t_mat = cv::Mat::zeros(2, 3, CV_32FC1);
	t_mat.at<float>(0,0) = 1;
	t_mat.at<float>(0,2) = 20;		//水平偏移量
	t_mat.at<float>(1,1) = 1;
	t_mat.at<float>(1,2) = 10;		//垂直偏移量

	//根据平移矩阵进行仿射变换
	cv::warpAffine(img, outimg, t_mat, img.size());

	cv::imshow("origin image", img);
	cv::imshow("out image", outimg);
	cv::waitKey(0);
	return 0;
}
```

运行结果：

![image-20210617191409791](https://cdn.jsdelivr.net/gh/Miller-em/IMAGS/img/20210617191410.png)

#### 旋转

图像的旋转具体实现分为两步：先根据旋转角度和旋转中心获取旋转矩阵；然后根据旋转矩阵进行仿射变换，即可实现任意角度和任意中心的旋转效果。旋转矩阵的形式如下：
$$
\left[\begin{array}{c}
\alpha & \beta & (1-\alpha) \cdot \text { center } \cdot x-\beta \cdot \text { center. } y \\
-\beta & \alpha & \beta \cdot \text { center. } x+(1-\alpha) \cdot \text { center } . y
\end{array}\right]
$$
其中：
$$
\begin{array}{l}
\alpha=\operatorname{scale} \cdot \cos \theta \\
\beta=\text { scale } \cdot \sin \theta
\end{array}
$$
以下为实例程序：

```
#include <iostream>
#include <opencv2/opencv.hpp>

int main(int argc, char** argv){
	cv::Mat img = cv::imread("lena.jpg");	//读取图片,以灰度图读入
	cv::Mat outimg;

	if (img.empty()){
		std::cout << "读取图片失败！" << std::endl;
		return -1;
	}

	//旋转角度
	double angle = 45;
	int len = std::max(img.cols, img.rows);

	//指定旋转中心
	cv::Point2f center(len/2, len/2);
	cv::Mat rot_mat = cv::getRotationMatrix2D(center, angle, 1.0);

	//根据旋转矩阵进行仿射变换
	cv::warpAffine(img, outimg, rot_mat, img.size());

	cv::imshow("origin image", img);
	cv::imshow("out image", outimg);
	cv::waitKey(0);
	return 0;
}
```

运行结果：

![image-20210617192701360](https://cdn.jsdelivr.net/gh/Miller-em/IMAGS/img/20210617192701.png)

#### 仿射变换

仿射变换是指在向量空间中进行一次线性变换(乘以一个矩阵)并加上一个平移(加上一个向量)，变换为另一个向量空间的过程。再OpenCV中利用warpAffine函数实现仿射变换，下面是**cv::warpAffine函数**：

```
void cv::warpAffine     (   InputArray      src,
        OutputArray     dst,
        InputArray      M,
        Size    dsize,
        int     flags = INTER_LINEAR,
        int     borderMode = BORDER_CONSTANT,
        const Scalar &      borderValue = Scalar() 
    )
```

参数解释

- src: 输入图像
- dst: 输出图像，尺寸由dsize指定，图像类型与原图像一致
- M: 2X3的变换矩阵
- dsize: 指定图像输出尺寸
- flags: 插值算法标识符，有默认值INTER_LINEAR，如果插值算法为WARP_INVERSE_MAP, warpAffine函数使用如下矩阵进行图像转换

**对图像做仿射变换主要是需要做出仿射矩阵。**该部分就不做示例了，要用的时候再添上。



#### 透视变换

我们在拍摄图片的时候无法保证图片是正下方垂直拍摄的，所以在获取图像的时候会防止我们提取正确的图像，这里我们就需要用到了**透视变换**。这部分是比较重要的，因为在车牌检测的时候，我们经常不能够获得一个正常角度的图片，利用透视变换可以将倾斜的照片变成我们正常习惯的视角。

在做透视变换的主要任务是：找到原图像的角点。

主要流程：

1. 灰度处理、二值化、形态学操作形成连通区域
2. 轮廓发现、将目标的轮廓绘制出来
3. 在绘制的轮廓中进行直线检测
4. 找出四条边，求出四个交点
5. 使用透视变换函数，得到结果

下面是示例代码：

```c++

```

### 2.OpenCV进行形态学转换

形态学操作是根据图像形状进行的简单操作。一般情况下对二值化图像进行的操作。需要输入两个参数，一个是原始图像，第二个被称为结构化元素或核，它是用来决定操作的性质的。两个基本的形态学操作是腐蚀和膨胀。他们的变体构成了开运算，闭运算，梯度等。下面会逐一介绍：

![image-20210626195357572](https://cdn.jsdelivr.net/gh/Miller-em/IMAGS/img/20210626195419.png)

#### 腐蚀

就像土壤侵蚀一样，这个操作会把前景物体的边界腐蚀掉（但是前景仍然是白色）。这是怎么做到的呢？卷积核沿着图像滑动，如果与卷积核对应的原图像的所有像素值都是 1，那么中心元素就保持原来的像素值，否则就变为零。这样就会造成白色区域缩小，就是上面的 **j** 变瘦了。下面是代码示例：

```c++
#include<opencv2/opencv.hpp>
#include<iostream>

int main(){
	cv::Mat src = cv::imread("J.jpg"), outimg;
	cv::namedWindow("Origin", cv::WINDOW_NORMAL);
	cv::imshow("Origin", src);

	//获取自定义核
	cv::Mat element = cv::getStructuringElement(cv::MORPH_RECT, cv::Size(9, 9));
	//腐蚀操作
	cv::erode(src, outimg, element);
	cv::namedWindow("Erode", cv::WINDOW_NORMAL);
	cv::imshow("Erode", outimg);
	cv::waitKey(0);
	return 0;
}
```

运行结果：

![image-20210626201905595](https://cdn.jsdelivr.net/gh/Miller-em/IMAGS/img/20210626201905.png)

#### 膨胀

与腐蚀相反，与卷积核对应的原图像的像素值中只要有一个是 1，中心元素的像素值就是 1。所以这个操作会增加图像中的白色区域（前景）。一般在去噪声时先用腐蚀再用膨胀。因为腐蚀在去掉白噪声的同时，也会使前景对象变小。所以我们再对他进行膨胀。这时噪声已经被去除了，不会再回来了，但是前景还在并会增加。膨胀也可以用来连接两个分开的物体。下面是示例程序：

```c++
#include<opencv2/opencv.hpp>
#include<iostream>

int main(){
	cv::Mat src = cv::imread("J.jpg"), outimg;
	cv::namedWindow("Origin", cv::WINDOW_NORMAL);
	cv::imshow("Origin", src);

	//获取自定义核
	cv::Mat element = cv::getStructuringElement(cv::MORPH_RECT, cv::Size(9, 9));
	//膨胀操作
	cv::dilate(src, outimg, element);
	cv::namedWindow("Erode", cv::WINDOW_NORMAL);
	cv::imshow("Erode", outimg);
	cv::waitKey(0);
	return 0;
}
```

运行结果：

![image-20210626202519693](https://cdn.jsdelivr.net/gh/Miller-em/IMAGS/img/20210626202519.png)

可以看出他们的差别就是换了一个api。

#### 其他形态学操作

- 开运算：先腐蚀再膨胀，用来消除小物体

- 闭运算：先膨胀再腐蚀，用于排除小型黑洞

- 形态学梯度：就是膨胀图与俯视图之差，用于保留物体的边缘轮廓。

- 顶帽：原图像与开运算图之差，用于分离比邻近点亮一些的斑块。

- 黑帽：闭运算与原图像之差，用于分离比邻近点暗一些的斑块。

这些掌握了基本的腐蚀和膨胀过后，这些就变得很简单，必要的时候再去查一查API使用。

### 3.OpenCV进行图像平滑

学习目标：

- 学习使用不同的低通滤波器对图像进行模糊
- 使用自定义的滤波器对图像进行卷积

#### 2D卷积

和一维信号一样，我们可以对二维图像信号进行低通滤波（LPF）和高通滤波（HPF）。LPF 帮助我们去除噪音，模糊图像。HPF 帮助我们找到图像的边缘。OpenCV提供了cv::filter2D对图像进行卷积操作。下面是利用平均滤波器对图像进行的滤波：

![image-20210626204909215](https://cdn.jsdelivr.net/gh/Miller-em/IMAGS/img/20210626204909.png)

#### 平均

这是由一个归一化卷积框完成的。他只是用卷积框覆盖区域所有像素的平均值来代替中心元素。可以使用函数 **cv::blur()** 和 **cv::boxFilter()** 来完这个任务。我们需要设定卷积框的宽和高。下面是一个 3x3 的归一化卷积框：
$$
K=\frac{1}{9}\left[\begin{array}{lll}
1 & 1 & 1 \\
1 & 1 & 1 \\
1 & 1 & 1
\end{array}\right]
$$
下面是示例代码：

```

```

运行结果：



#### 高斯模糊

现在把卷积核换成高斯核（简单来说，方框不变，将原来每个方框的值是相等的，现在里面的值是符合高斯分布的，方框中心的值最大，其余方框根据距离中心元素的距离递减，构成一个高斯小山包。原来的求平均数现在变成求加权平均数，全就是方框里的值）。实现的函数是 **cv::GaussianBlur()**。我们需要指定高斯核的宽和高（必须是奇数）。以及高斯函数沿 X，Y 方向的标准差。如果我们只指定了 X 方向的的标准差，Y 方向也会取相同值。如果两个标准差都是 0，那么函数会根据核函数的大小自己计算。高斯滤波可以有效的从图像中去除**高斯噪音**。

下面是示例代码：

```

```

运行结果：

#### 中值模糊

顾名思义就是用与卷积框对应像素的中值来替代中心像素的值。这个滤波器经常用来去除**椒盐噪声**。前面的滤波器都是用计算得到的一个新值来取代中心像素的值，而中值滤波是用**中心像素周围（也可以使他本身）的值来取代他**。他能有效的去除噪声。卷积核的大小也应该是一个奇数。在这个例子中，我们给原始图像加上 50% 的噪声然后再使用中值模糊。

下面是示例代码：

```

```

运行结果：

#### 双边滤波

双边滤波在同时使用空间高斯权重和灰度值相似性高斯权重。空间高斯函数确保只有邻近区域的像素对中心点有影响，灰度值相似性高斯函数确保只有与中心像素灰度值相近的才会被用来做模糊运算。所以这种方法会**确保边界不会被模糊掉**，因为边界处的灰度值变化比较大。

下面是示例代码：

```

```

运行结果：

###  4.OpenCV进行边缘检测

