---
title: hexo next主题解决无法显示Latex数学公式
date: 
tags: ['hexo']
categories: 博客
top: false
---

最近想写一遍关于傅里叶变换的文章，但是我发现**Hexo** **Next**主题下无法对**Latex**数学公式进行渲染，这个就让我显得很苦恼，因为数学公式实在是太多了，说明这类问题不用公式又不好理解，所以一定要解决这种问题。后来我通过百度发现了**原因**：

> Hexo 默认使用 `hexo-renderer-marked` 引擎渲染网页，该引擎会把一些特殊的 `markdown` 符号转换为相应的 `html` 标签，比如在 `markdown` 语法中，下划线`_`代表斜体，会被渲染引擎处理为`<em>`标签。
>
> 因为类 `Latex` 格式书写的数学公式下划线`_`表示下标，有特殊的含义，如果被强制转换为`<em>`标签，那么 `MathJax` 引擎在渲染数学公式的时候就会出错。
>
> 类似的语义冲突的符号还包括`*, {, }, \\`等。

<!-- more -->

## 解决方案

更换 Hexo 的 markdown 渲染引擎，hexo-renderer-kramed 引擎是在默认的渲染引擎 hexo-renderer-marked 的基础上修改了一些 bug ，两者比较接近，也比较轻量级。

```
npm uninstall hexo-renderer-marked --save
npm install hexo-renderer-kramed --save
```

执行上面的命令即可，先卸载原来的渲染引擎，再安装新的。
然后，跟换引擎后行间公式可以正确渲染了，但是这样还没有完全解决问题，行内公式的渲染还是有问题，因为 `hexo-renderer-kramed` 引擎也有语义冲突的问题。接下来到博客根目录下，找到`node_modules\kramed\lib\rules\inline.js`，把第11行的 escape 变量的值做相应的修改：

```
//escape: /^\\([\\`*{}\[\]()#$+\-.!_>])/,
escape: /^\\([`*\[\]()#$+\-.!_>])/,
```

这一步是在原基础上取消了对`\,{,}`的转义(escape)。
同时把第20行的em变量也要做相应的修改。

```
//em: /^\b_((?:__|[\s\S])+?)_\b|^\*((?:\*\*|[\s\S])+?)\*(?!\*)/,
em: /^\*((?:\*\*|[\s\S])+?)\*(?!\*)/,
```

重新启动hexo（先clean再generate）,问题完美解决。哦，如果不幸还没解决的话，看看是不是还需要在使用的主题中配置**mathjax**开关。

### 在 Next 主题中开启 MathJax 开关

如果使用了主题，别忘了在主题（Theme）中开启 MathJax 开关，下面以 next 主题为例，介绍下如何打开 MathJax 开关。

进入到主题目录，找到 _config.yml 配置问题，把 math 默认的 false 修改为true，具体如下：

```
# Math Equations Render Support
math:
  enable: true

  # Default(true) will load mathjax/katex script on demand
  # That is it only render those page who has 'mathjax: true' in Front Matter.
  # If you set it to false, it will load mathjax/katex srcipt EVERY PAGE.
  per_page: true

  engine: mathjax
  #engine: katex
```

还需要在文章的Front-matter里打开mathjax开关，如下：

```
---
title: index.html
date: 2018-07-05 12:01:30
tags:
mathjax: true
--
```

之所以**要在文章头里设置开关**，是因为考虑只有在用到公式的页面才加载 Mathjax，这样不需要渲染数学公式的页面的访问速度就不会受到影响了。