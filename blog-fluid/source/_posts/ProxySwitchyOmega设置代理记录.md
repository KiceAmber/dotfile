---
title: ProxySwitchyOmega设置代理记录
date: 2023-12-25 16:43:52
tags: 代理工具
categories: 零珠碎玉
---

参考文章：https://www.nite07.com/switchyomegaguide/index.html

# 下载插件

github 地址: https://github.com/FelisCatus/SwitchyOmega

建议还是在浏览器自带的扩展插件商店下载，比如我使用的是 Vivaldi 浏览器，下载 github 中的 crx 文件，在开发者模式中安装还是会报错

最后还是从 chrome 插件商店下载才安装成功

# 配置 Proxy 自动切换代理

插件刚下载时，会存在默认的情景模式，我这里将其都删除并且创建了两个自定义的模式，如下图所示：

![](https://s11.ax1x.com/2023/12/25/piHfVnf.png)

我的 clash 设置的代理端口就是默认的 7890，所以这里也设置为 `127.0.0.1:7890` 

其中 auto switch 中的设置如下图所示：

![](https://s11.ax1x.com/2023/12/25/piHfUN4.png)

这里要添加规则列表网址，填入 `https://g-raw.nite07.org/gfwlist/gfwlist/master/gfwlist.txt`

然后会提示数据已经过时，点击 **立即更新情景模式** 即可，等待数据的更新完毕

增加一条新的切换规则，也就是：

![](https://s11.ax1x.com/2023/12/25/piHffCd.png)

最后一定要点击左边的 `应用选项`，否则不会其作用

![](https://s11.ax1x.com/2023/12/25/piHf5vt.png)

这样设置完成后，点击扩展图标，将其模式设置为 auto switch 即可

# 后话

系统是 Linux，所以本身的 clash 客户端并没有系统代理的选项

之前都是使用火狐单独设置代理，所以都是两个浏览器，一个火狐用于访问外网，Vivaldi 用于墙内

现在使用这个插件后，就可以在一个浏览器内单独设置需要使用代理的网址，非常方便