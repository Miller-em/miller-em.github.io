---
title: ICDAR2019-LSVT 数据集预处理
date: 
tags: ['OCR', 'paddle', '数据集']
categories: 深度学习
top: false
---

对于OCR要实现识别中文字符，数据集的选择是非常重要的，一定要是中文数据集。这里选择使用ICDAR2019-LSVT。因为给定的数据集，不符合**PaddleOCR**的train.py能够识别的格式，同时官方没有提供测试集的label，所以我们要将其进行调整：从官方给的训练集重新划分训练集和测试集，同时为其生成对应的label文件。

## 数据集的选择

**数据简介**： ICDAR2019-LSVT共包括45w中文街景图像，包含5w（2w测试+3w训练）全标注数据（文本坐标+文本内容），40w弱标注数据（仅文本内容），如下图所示：

 <!-- more -->

![image-20210409153118954](https://cdn.jsdelivr.net/gh/Miller-em/IMAGS/img/20210409153119.png)

这里考虑数据集太大的原因，所以只选择了全标注的数据集作为训练集和测试集。一共3w张图片。所以这里就下载了三个文件：`train_full_images_0.tar.gz`，`train_full_images_0.tar.gz`，`train_full_labels.json`



数据集下载地址：https://ai.baidu.com/broad/download?dataset=lsvt

## 划分训练集和测试集

我先将下载的两个数据集合成了一个full_images，里面一共有3w张图片。现在需要做的是分成训练集和测试集比例为8：2，分别放在train_images, test_images文件夹下面。

直接贴上代码：

```python
import os
import shutil
import argparse

def split(args, images_names):
    origin_images_path = args.images_dir_path
    save_train_dir_path = args.train_dir_path
    save_test_dir_path = args.test_dir_path

    rate = 0.8
    train_images = images_names[:int(rate*len(images_names))]
    test_images = images_names[int(rate*len(images_names)):]
    
    for train_image in train_images:
        origin_image_path = os.path.join(origin_images_path, train_image)
        save_image_path = os.path.join(save_train_dir_path, train_image)
        shutil.copy(origin_image_path, save_image_path)

    for test_image in test_images:
        origin_image_path = os.path.join(origin_images_path, test_image)
        save_image_path = os.path.join(save_test_dir_path, test_image)
        shutil.copy(origin_image_path, save_image_path)

def load_images(args):
    origin_images_path = args.images_dir_path
    for dirpath, dirnames, filesnames in os.walk(origin_images_path):
        print("原数据集的图片数量为：", len(filesnames))

    return filesnames 
    

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--images_dir_path',
                         type=str, 
                         default='./train_data/ICDAR2019-LSVT/full_images/',
                         help='原数据集的路径')
    parser.add_argument('--train_dir_path',
                         type=str, 
                         default='./train_data/ICDAR2019-LSVT/train_images/',
                         help='保存训练集的路径')
    parser.add_argument('--test_dir_path',
                         type=str, 
                         default='./train_data/ICDAR2019-LSVT/test_images/',
                         help='保存测试集的路径')
    args = parser.parse_args()
    images_names = load_images(args)
    split(args, images_names)


if __name__ == "__main__":
    main()
```



## 生成对应的label

训练集和测试集分好了，最后需要是生成训练集和测试集的label文件，这样才能够训练。

直接贴上代码：

```python
import json
import os

def main():
    json_path = './train_data/ICDAR2019-LSVT/full_labels.json'
    test_imgs_path = './train_data/ICDAR2019-LSVT/test_images/'
    with open(json_path, 'r') as f:
        data = json.load(f)
    train_imgs_path = './train_data/ICDAR2019-LSVT/train_images/'
    
    with open('./train_data/ICDAR2019-LSVT/train_label.txt', 'w') as fw:
        for dirpath, dirnames, images_names in os.walk(train_imgs_path):
            imgs_num = len(images_names)
            print("该训练集的数量为：", imgs_num)
        
        for images_name in images_names:
            image_path = 'train_images/' + images_name
            fname, fename = os.path.splitext(images_name)
            image_label = image_path + '\t' + json.dumps(data[fname]) + '\n'
            fw.write(image_label)
        fw.close()
    
    with open('./train_data/ICDAR2019-LSVT/test_label.txt', 'w') as fb:
        for dirpath, dirnames, images_names in os.walk(test_imgs_path):
            imgs_num = len(images_names)
            print("该测试集的数量为：", imgs_num)
        
        for images_name in images_names:
            image_path = 'test_images/' + images_name
            fname, fename = os.path.splitext(images_name)
            image_label = image_path + '\t' + json.dumps(data[fname]) + '\n'
            fb.write(image_label)
        fb.close()
   

if __name__ == "__main__":
    main()
```

