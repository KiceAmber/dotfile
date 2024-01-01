---
title: Docker环境搭建
date: 2022-9-11 20:05:32
tags:
  - 云原生
  - Docker
---

# Docker 下载安装

## Windows 系统

因为主力机是 Linux 🥳，而且也推荐在 Linux 系统上来操作 Docker

Win 系统就不详细记录了，因为我的 Win 上面也是使用 WSL2 来配置开发环境的，所以严格意义上讲，还是 Linux 的环境

## Linux 系统

使用的是 ArchLinux，有 AUR，下载安装 Docker 也是非常方便 

```shell
yay -S docker # 安装 docker

yay -S docker-compose # 安装 docker-compose

sudo systemctl start docker # 开启Docker服务

sudo systemctl enable docker # 允许Docker服务开机自启动

sudo systemctl status docker # 验证Docker服务运行状态

docker version # 查看Docker版本

sudo groupadd docker # 若没有docker组,就新建一个docker组

sudo gpasswd -a ${USER} docker # 将当前用户加入docker组中

newgrp ${USER} # 刷新组缓存,即时生效
```

执行上述命令后，记得注销或者重启系统

# 配置 Docker 网络代理

在 `/etc/systemd/system` 目录下新建 `docker.service.d` 目录

```shell
sudo mkdir -p /etc/systemd/system/docker.service.d
```

然后创建 `http-proxy.conf` 文件，编辑该文件

```shell
sudo vim /etc/systemd/system/docker.service.d/http-proxy.conf
```

添加代理配置

```conf
[Service]
Environment="HTTP_PROXY=http://127.0.0.1:7890/"
Environment="HTTPS_PROXY=http://127.0.0.1:7890/"
```

保存退出后，重新启动 docker

```shell
sudo systemctl daemon-reload

sudo systemctl restart docker
```

> 这里的网络代理，就是设置发送流量的端口，`7890` 其实是代理软件中设置的端口
> 
> 所以配置 docker 的网络代理之前，记得先搞好代理软件，比如 clash 之类的(阿巴阿巴阿巴...)