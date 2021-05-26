---
title: Yolov1-论文解读笔记
date: 
tags: 目标检测
categories: 论文
top: false
mathjax: true
---

涉足目标检测领域，不仅仅是在盲目的做数据集，训练，调参。而是要解读背后的算法，这样才会在能力上面有更大的提升。所以我现在开始对yolo系列的论文进行解读。这一篇是关于YOLOv1的解读，现在还不知道具体的读后感。到时候读完在结语写出吧~

<!-- more -->

## 摘要解读

YOLO_v1 的作者提出，YOLO算法采用了一种不同与之前的目标检测的方法(之前的方式是利用的**分类器**来检测) --回归，这个回归问题实现空间分离的边界框和分类概率。YOLOv1的模型能以每秒45帧的速度处理图像。总之，就是YOLO实现了用回归执行检测目标，而且在推理速度得到了提升。

## 介绍

YOLO将物体检测任务当做回归任务来处理，直接通过整个图片的所有像素得到bounding box的坐标，和box内的置信度和class probabilities。在YOLO中，只需要输入到神经网络就能得出图像中有哪些物体和物体的位置。

- 这是YOLO目标检测的大致流程：

![image-20210522212408645](https://cdn.jsdelivr.net/gh/Miller-em/IMAGS/img/20210522212508.png)

**YOLO的优点是**：

- Yolo相比其他的目标检测算法来说，更加的简单，原因在于Yolo采用的是一个单一的神经网络，直接得到目标的bounding box 的位置和置信度，分类概率。
- Yolo检测非常快， 由于将检测框架视为回归问题，因此不需要复杂的流程。只需要测试时在新图像上运行神经网络即可检测到结果。Yolo在Titan X GPU上，标准版本的Yolo系统可以每秒处理45张图像， Fast Yolo可以处理150帧图像。
- Yolo解释了做预测时，对于图像的全局问题。相比于滑动窗口，Yolo看到的是全局的图像，当图像在做训练和测试的时候。
- YOLO 学到物体更泛化的特征表示。当在自然场景图像上训练 YOLO，再在 艺术图像上去测试 YOLO 时，YOLO 的表现要优于 DPM、R-CNN。YOLO 模型更能适应新的领域，由于其是高度可推广的，即使有非法输入，它也不太可能崩溃。

**YOLO的缺点：**

- YOLO在准确性方面仍落后于最新的检测系统。尽管它可以快速识别图像中的对象，但是在定位方面效果不太好，尤其是定位小型对象目标。

## 统一检测

我们的系统将输入图像划分为**S×S**网格。如果目标对象的中心落入网格单元，则该网格单元负责检测该对象。每个网格单元预测**B**个边界框和这些框的置信度得分。这些置信度得分反映了该模型对这个网格包含一个对象的置信度（是否有目标对象），以及它认为网格预测的准确性。形式上，我们将**置信度**定义为：

$$
\operatorname{Pr}(\text { Object }) * \text { IOU }_{\text {preed }}^{\text {truth }}
$$

Pr(Object)表示其网格单元（注意是网格单元不是边界框）内是否含有目标对象，如果该单元格中没有对象，即Pr(Object) 为0，则置信度分数应为零。否则，则表示含有目标对象，Pr(Object) 为1，置信度分数等于预测框与真实框的交并比（IOU）（数值在[0,1]之间，数值越大说明重合区域越大，得分越高）。

每个边界框由5个预测组成：x，y，w，h和置信度。 （x，y）坐标表示边界框相对于网格单元边界的中心。（w，h）相对于整个图像预测宽度和高度。最后，置信度预测表示预测框与任何地面真实框之间的IOU。

每个网格单元还预测**C**个条件类概率，$\operatorname{Pr}($ Class $\mid$ Object $)$ ，这些概率以包含对象的网格单元为条件。 无论预测边界框**B**的数量如何，都仅预测每个网格单元的一组类概率，也就是说每个网格单元预测一组类概率。

在测试时，将条件类别的概率和各个预测框的置信度相乘：

$$
\operatorname{Pr}\left(\text { Class }_{i} \mid \text { Object }\right)^{*} \operatorname{Pr}(\text { Object })^{*} I O U_{\text {pred }}^{\text {truth }}=\operatorname{Pr}\left(\text { Class }_{i}\right)^{*} \text { IOU }_{\text {pred }}^{\text {truth }}
$$

这样既可得到每个bounding box的具体类别的confidence score。这乘积既包含了bounding box中预测的class的 probability信息，也反映了bounding box是否含有Object和bounding box坐标的准确度。（显然如果cell中不含有目标对象，则乘积直接为0）



大致流程如下：

![image-20210522222312413](https://cdn.jsdelivr.net/gh/Miller-em/IMAGS/img/20210522222312.png)



将YOLO用于PASCAL VOC数据集时：论文使用的 S=7，即将一张图像分为7×7=49个网格每一个网格预测B=2个boxes（每个box有 x,y,w,h,confidence，5个预测值），同时C=20（PASCAL数据集中有20个类别）。因此，最后的prediction是7×7×30 { 即S * S * ( B * 5 + C) }的Tensor（张量）



### 网络设计

YOLO网络借鉴了GoogLeNet分类网络结构。 **网络有24个卷积层，其后是2个全连接的层**，不同的是，YOLO未使用inception module，而是使用1x1卷积层（此处1x1卷积层的存在是为了跨通道信息整合）+3x3卷积层简单替代。最终输出的是7x7x30的张量的预测值。具体如下图所示：
![image-20210523200153465](https://cdn.jsdelivr.net/gh/Miller-em/IMAGS/img/20210523200153.png)

### 训练

首先利用ImageNet 1000-class的分类任务数据集Pretrain卷积层。使用上述网络中的前20 个卷积层，加上一个 average-pooling layer，最后加一个全连接层，作为 Pretrain 的网络。训练大约一周的时间，使得在ImageNet 2012的验证数据集Top-5的精度达到 88%，这个结果跟 GoogleNet 的效果相当。

将Pretrain的结果的前20层卷积层应用到Detection中，并加入剩下的4个卷积层及2个全连接。同时为了获取更精细化的结果，将输入图像的分辨率由 224* 224 提升到 448* 448。将所有的预测结果都归一化到 0~1, 使用 Leaky RELU 作为激活函数。 Leaky RELU的公式如下：
$$
\phi(x)=\left\{\begin{array}{ll}
x, & \text { if } x>0 \\
0.1 x, & \text { otherwise }
\end{array}\right.
$$
Leaky RELU可以解决RELU的梯度消失问题。



**损失函数：**

在实现中，最主要的就是怎么设计损失函数，让这个三个方面得到很好的平衡。作者简单粗暴的全部采用了**sum-squared error loss**来做这件事。

大概就是下面这个形式，目前看不大懂，等以后再研究吧：
$$
\begin{array}{l}
\lambda_{\text {coord }} \sum_{i=0}^{S^{2}} \sum_{j=0}^{B} \mathbb{1}_{i j}^{\text {obj }}\left[\left(x_{i}-\hat{x}_{i}\right)^{2}+\left(y_{i}-\hat{y}_{i}\right)^{2}\right] \\
\quad+\lambda_{\text {coord }} \sum_{i=0}^{S^{2}} \sum_{j=0}^{B} \mathbb{1}_{i j}^{\text {obj }}\left[\left(\sqrt{w_{i}}-\sqrt{\hat{w}_{i}}\right)^{2}+\left(\sqrt{h_{i}}-\sqrt{\hat{h}_{i}}\right)^{2}\right] \\
+\sum_{i=0}^{S^{2}} \sum_{j=0}^{B} \mathbb{1}_{i j}^{\text {obj }}\left(C_{i}-\hat{C}_{i}\right)^{2} \\
+\sum_{i=0}^{S^{2}} \mathbb{1}_{i}^{\text {obj }} \sum_{c \in \text { classes }}\left(p_{i}(c)-\hat{p}_{i}(c)\right)^{2}
\end{array}
$$




中间的就是和其他的模型的比较，就不做记录了。

## 总结

论文介绍一篇通用性的目标检测方法——YOLO，模型构造简单，可以直接在整个图片上训练。不想基于分类的方式，YOLO在直接对应检测性能的损失函数上训练，使整个模型联合训练。FastYOLO是文献中YOLO中最快的通用对象检测器，YOLO推动了最先进的实时目标检测。YOLO还很好地推广到新领域，使其成为依赖于快速、健壮的对象检测的应用程序。