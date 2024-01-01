---
title: Go深入了解channel
date: 2023-11-17 10:02:15
tags:
  - Golang
  - 并发编程
---


传统的多线程编程，是基于 `Shared Memory` 来实现的，也就是共享内存的方式

有并发肯定就会有数据竞争，共享内存中，并发数据竞争的问题是通过加锁或者同步原语来解决的，通过加锁的方式来强制让线程顺序执行

在 Go 中提倡的是 **使用通信来共享内存，而不是通过共享内存来实现通信**，初学 Go 的并发编程时，这句话就出现在了很多博客和官方教程甚至源码中

使用通信来共享内存实际就是发送消息来同步，这种方式最常见的就是 Go 采用的 **CSP** 模型以及 Erlang 采用的 **Actor** 模型

Go 引入了 channel 和 goroutine 的方式来实现 CSP 模型



# channel 底层实现

```go
type hchan struct {
    qcount   uint           // 队列中元素总数量
    dataqsiz uint           // 循环队列的长度
    buf      unsafe.Pointer // 指向长度为 dataqsiz 的底层数组，只有在有缓冲时这个才有意义
    elemsize uint16         // 能够发送和接受的元素大小
    closed   uint32         // 是否关闭
    elemtype *_type         // 元素的类型
    sendx    uint           // 当前已发送的元素在队列当中的索引位置
    recvx    uint           // 当前已接收的元素在队列当中的索引位置
    recvq    waitq          // 接收 Goroutine 链表
    sendq    waitq          // 发送 Goroutine 链表

    lock mutex // 互斥锁
}

// waitq 是一个双向链表，里面保存了 goroutine
type waitq struct {
    first *sudog
    last  *sudog
}
```

如下图所示，channel 的底层数据结构其实是一个循环队列
