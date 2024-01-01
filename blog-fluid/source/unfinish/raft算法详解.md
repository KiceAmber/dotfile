---
title: Raft算法详解
date: 2023-12-22 08:39:33
tags: 
  - 分布式
  - 云原生
---

# 什么是 Raft 算法

Raft 算法是一种通过对 **日志复制管理** 来达到集群节点一致性的算法，这个日志复制管理发生在集群节点中 Leader 和 Follower 之间

Raft 通过选举出的 Leader 节点来负责管理日志复制过程，以实现各个节点间数据的一致性

也就是说，Raft 算法由两个步骤构成：

1. 集群中 Leader 节点的选举
2. 由 Leader 节点来管理日志复制，从而实现节点数据一致性

# Raft 中的相关概念

Raft 中有三种角色：

- Leader：唯一负责客户端写请求的节点，也可以负责客户端的读请求，同时负责日志复制工作
- Candidate：Leader 选举的候选人，其可能会成为 Leader，是选举过程中的角色
- Follower：可以处理客户端的读请求，负责同步来自 Leader 的日志，当接收到其他 Candidate 的投票请求后，可以进行投票，当发现 Leader 挂了，其会转变为 Candidate 发起 Leader 选举

# Raft 选举过程

![](https://pic2.zhimg.com/v2-7f64a2df8f8817932ed047d35878bca9_r.jpg)

> 或许这个网站的动画可以更深入理解 Raft 算法的执行流程: http://www.kailing.pub/raft/index.html#intro

