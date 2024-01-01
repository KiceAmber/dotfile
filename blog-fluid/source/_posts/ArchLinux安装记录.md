---
title: ArchLinux安装记录
date: 2022-10-01 22:49:10
tags: Linux
---

用 Arch 已经快半年了，无论是日常体验还是开发体验确实相比于 Windows 都要好很多，除了打游戏稍微有点麻烦(双系统真香)

本文章用于记录安装 ArchLinux 过程

# 💽 系统镜像下载

> 👉 ArchLinux 官网镜像下载地址：https://archlinux.org/download/

- Windows 系统使用 [rufus](https://rufus.ie/zh/) 来刻录系统盘
- Linux 系统可以使用 `dd` 命令来直接刻录系统盘

# 🚀 安装系统

## 环境启动

实体机需插入U盘, 虚拟机则直接启动即可

进入 GRUB 界面后, 默认第一项 `Arch Linux install medium (x86_64, UEFI)`

等待安装环境启动，如果出现下面的内容，说明安装环境启动成功，所有的安装过程都会在终端进行：

```shell
Arch Linux 6.x.x-arch1-1 (tty1)

archiso login: root (automatic login)

To install Arch Linux follow the installation guide:
https://wiki.archlinux.org/title/Installation_guide

...
```

## 验证启动模式

必须使用 UEFI 模式启动，输入下面的命令来验证启动模式

```shell
ls /sys/firmware/efi/efivars
```

如果有大量的输出，说明处于 UEFI 模式，若是出现下面的内容，说明处于 BIOS 模式

```shell
ls: cannot access '/sys/firmware/efi/efivars': No such file or directory
```

## 连接网络

是实体机安装中，ArchLinux 的 Live 环境需要手动连接网络

当然也可以 **有线连接** 或者 **手机 USB 共享网络**，这里使用 `iwctl` 命令来连接 wifi

```shell
iwctl # 进入交互式命令行

device list device list # 列出无线网卡设备名，比如无线网卡看到叫 wlan0

station wlan0 scan # 扫描网络

station wlan0 get-networks # 列出所有 wifi 网络

station wlan0 connect "wifi-name" # 连接wifi,这里无法输入中文

exit # 连接成功后退出
```

连接后使用 `ping` 命令测试是否连接成功

```shell
ping archlinux.org

PING archlinux.org (95.217.163.246) 56(84) bytes of data.
64 bytes from archlinux.org (95.217.163.246): icmp_seq=1 ttl=47 time=201 ms
64 bytes from archlinux.org (95.217.163.246): icmp_seq=2 ttl=47 time=218 ms
64 bytes from archlinux.org (95.217.163.246): icmp_seq=3 ttl=47 time=194 ms
```

## 磁盘分区

|  挂载点   |            分区             |     分区类型      |        建议大小        |          备注          |
| :-------: | :-------------------------: | :---------------: | :--------------------: | :--------------------: |
| /mnt/efi  | /dev/sda1 或 /dev/nvme0n1p1 |    EFI System     |        512 MiB         |        ESP 分区        |
|   /mnt    | /dev/sda2 或 /dev/nvme0n1p2 | Linux x86-64 root | 100 GiB（至少 20 GiB） |   ArchLinux 的根分区   |
| /mnt/home | /dev/sda3 或 /dev/nvme0n1p3 |    Linux home     |    剩余所有磁盘空间    | ArchLinux 的 home 分区 |

```shell
lsblk # 查看设备信息
```

这里使用 fdisk 工具来对磁盘进行分区(这里记录的虚拟机安装 archlinux 的分区过程，给虚拟机分配的磁盘大小为 30G)

```shell
fdisk /dev/sda # 工具 fdisk 对 /dev/sda 分区
 
Command (m for help): g  # 输入 g 创建新的 GPT 分区表(请勿遗忘此步，否则硬盘将是 MBR 格式)
Created a new GPT disklabel (GUID: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx).

Command (m for help): n  # 输入 n 创建新的分区，这个分区将是 EFI 分区
Partition number (1-128, default 1):  # 分区编号保持默认，直接按 Enter
First sector (2048-125829086, default 2048):  # 第一个扇区，保持默认
Last sector, +/-sectors or +/-size{K,M,G,T,P} (2048-125829086, default 125827071): +512M  # 创建 512MiB 大小的分区
Created a new partition 1 of type 'Linux filesystem' and of size 512 MiB.

Command (m for help): t  # 输入 t 改变分区类型，请勿遗忘此步
Selected partition 1
Partition type or alias (type L to list all): 1  # 输入 1 代表 EFI 类型
Changed type of partition 'Linux filesystem' to 'EFI System'.

Command (m for help): n  # 创建第二个分区，用作根分区
Partition number (2-128, default 2):   # 保持默认
First sector (1050624-125829086, default 1050624):   # 保持默认
Last sector, +/-sectors or +/-size{K,M,G,T,P} (1050624-125829086, default 125827071): +20G  # 创建 20 GiB 大小的根分区，您可以根据自己的硬盘空间决定根分区的大小

Command (m for help): t  # 输入 t 改变分区类型，请勿遗忘此步
Partition number (1-2, default 2):   # 保持默认
Partition type or alias (type L to list all): 23  # 输入 23 代表 Linux root (x86-64) 类型
Changed type of partition 'Linux filesystem' to 'Linux root (x86-64)'.

Command (m for help): n  # 创建第三个分区，用作 home 分区
Partition number (3-128, default 3):   # 默认
First sector (42993664-125829086, default 42993664):   # 保持默认
Last sector, +/-sectors or +/-size{K,M,G,T,P} (42993664-125829086, default 125827071): #保持默认，将剩余空间全部分给 home 分区

Command (m for help): t  # 输入 t 改变分区类型
Partition number (1-3, default 3): # 默认
Partition type or alias (type L to list all): 42  # 输入 42 代表 Linux home 类型
Changed type of partition 'Linux filesystem' to 'Linux home'.

Command (m for help): p  # 输入 p 打印分区表，请检查分区是否有误，如果有误，请输入 q 直接退出
Disk /dev/sda: xx GiB, xxxxxx bytes, xxxxxx sectors
Disk model: xxx
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disklabel type: gpt
Disk identifier: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx

Device        Start        End   Sectors   Size  Type
/dev/sda1      2048    1050623   1048576   512M  EFI System
/dev/sda2   1050624   42993663  41943040    20G  Linux root (x86-64)
/dev/sda3  42993664   62912511  19918848   9.5G  Linux home

Command (m for help): w  # 输入 w 写入分区表，该操作不可恢复
The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.
```

## 分区格式化

```shell
mkfs.ext4 /dev/sda2      # 将 root 目录格式化为 ext4 文件系统

mkfs.ext4 /dev/sda3      # 将 home 目录格式化为 ext4 文件系统

mkfs.fat -F 32 /dev/sda1 # 将 EFI 分区格式化为 FAT32 文件系统
```

## 挂载分区

将根分区挂载在 **/mnt** 目录下，**这里一定要先挂载根分区**

```shell
mount /dev/sda2 /mnt
```

随后，创建 **/mnt/efi** 目录，并将 EFI 分区挂载在 **/mnt/efi** 目录下

```shell
mount --mkdir /dev/sda1 /mnt/efi # 创建并挂载
```

> 🚧 注意！
>
> 如果这里安装的是双系统，`/dev/sda1` 需要修改成 Windows 的 EFI 分区，让 ArchLinux 和 Windows 共用一个 EFI 分区

最后，挂载 **home** 分区

```shell
mount --mkdir /dev/sda3 /mnt/home
```

## 创建交换分区

交换文件相当于 Windows 中的虚拟内存，也就是利用硬盘空间充当内存

当内存相对不足时，有部分内存中的内容会交换到磁盘中，从而释放内存

| 内存大小           | 4G   | 8G   | 16G  | 32G  |
| ------------------ | ---- | ---- | ---- | ---- |
| 推荐的交换文件大小 | 6G   | 8G   | 10G  | 13G  |

创建交换文件，创建一块 13G(13312 MiB) 大小的交换文件

```shell
dd if=/dev/zero of=/mnt/swapfile bs=1M count=13312 status=progress # 创建交换文件
chmod 0600 /mnt/swapfile                                          # 修改权限

# 格式化并启用 swap
mkswap -U clear /mnt/swapfile  
swapon /mnt/swapfile
```

## 选择软件仓库镜像

ArchLinux中，软件仓库就好比手机中的应用商店，软件包是通过软件仓库进行分发的

软件仓库镜像是软件仓库的复制品，同一个软件仓库可以在世界各地建立软件仓库镜像，以便于不同地区的用户下载

因此选择一个合适的软件仓库镜像对于更新软件包数据库以及下载软件包的速度有很大影响

编辑 `/etc/pacman.d/mirrorlist`，手动设置镜像源

```shell
vim /etc/pacman.d/mirrorlist
```

这里使用北外源、清华源以及中国科学技术大学镜像，记得将下面的内容放在最前面

```shell
Server = https://mirrors.bfsu.edu.cn/archlinux/$repo/os/$arch
Server = https://mirrors.tuna.tsinghua.edu.cn/archlinux/$repo/os/$arch
Server = https://mirrors.ustc.edu.cn/archlinux/$repo/os/$arch
```

## 安装 Linux 基础包

使用 **pacstrap** 安装 base，linux，linux-firmware 三个软件包，它们分别是 **基础包组**，**linux 内核** 和 **驱动程序**

```shell
pacman-key --init  # 初始化密钥环
pacman-key --populate
pacman -Sy archlinux-keyring
```

使用 packtrap 安装包

```shell
pacstrap -K /mnt base linux linux-firmware sof-firmwar # sof-firmware 可选，也可以后安装
```

## 创建 fstab 文件

fstab 是一个系统文件，决定了系统启动时如何自动挂载分区，没有 fstab，系统将找不到根分区，从而无法启动

ArchLinux 提供了自动生成 fstab 的工具，利用它直接生成

```shell
genfstab -U /mnt >> /mnt/etc/fstab # 生成 fstab 文件
cat /mnt/etc/fstab                 # 检查文件内容是否正确
```

## chroot 切换系统

可以使用 arch-chroot 工具切换到新安装的系统，以后的操作就可以在新安装的系统中完成了

```shell
arch-chroot /mnt
```

执行上述命令后，就会进入到真正的 archlinux 系统中，前面所有的操作都是处于 live 环境中进行的

## 时区设置

中国地区的使用 **上海时间**，在其他地区的可以在输入 **/usr/share/zoneinfo/** 之后按下 `Tab` 键查看可选的时区

```shell
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
```

然后设置硬件时间

```shell
hwclock --systohc
```

## 本地化 locale

locale 决定了系统的语言和格式，包括终端显示哪种语言，数字、时间和货币以哪国的格式显示等等

```shell
pacman -S vim terminus-font # 安装 vim 和 terminus-font 
```

打开 `/etc/locale.gen`，将 en_US.UTF-8 和 zh_CN.UTF-8 前的注释去掉

```shell
# 将下列的内容的注释去掉，保存退出
en_US.UTF-8 UTF-8
zh_CN.UTF-8 UTF-8
```

然后生成 `locale-gen`

```shell
locale-gen
```

创建编辑 `/etc/locale.conf` 文件，加入下面的内容，保存退出

```shell
LANG=en_US.UTF-8
```

最后就是永久设置终端字体，在 `/etc/vconsole.conf` 文件添加下面这句话

```shell
FONT=ter-124n
```

## 网络配置

使用 `vim /etc/hostname` 编辑 hostname 文件，设置主机名，这将是计算机的名字

```shell
hostname
```

安装一个网络管理器，推荐使用 NetworkManager

```shell
pacman -S networkmanager

systemctl enable NetworkManager.service # 使用 systemd 设置 NetworkManager 开机自动启动
```

## 设置 root 密码

root 用户是 Linux 系统中权限最高的用户，有些敏感的操作必须通过 root 用户进行，比如使用 pacman

```shell
passwd # 设置 root 用户密码

New password:  # 输入密码，这里不会有显示
Retype new password:
passwd: password updated successfully
```

## 引导加载程序

为了启动 ArchLinux，必须使用一个引导加载程序，推荐使用 GRUB

首先需要根据CPU型号安装对应的微码

```shell
cat /proc/cpuinfo | grep "model name" # 查看 CPU 型号

pacman -S intel-ucode # Intel CPU，安装 intel-ucode
pacman -S amd-ucode   # AMD CPU，安装 amd-ucode
```

ArchLinux 引导加载程序安装

```shell
pacman -S grub efibootmgr                                                   # 安装必要的软件包
grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=GRUB # 安装 GRUB 到计算机
grub-mkconfig -o /boot/grub/grub.cfg                                        # 生成 GRUB 配置
```

> 🚧 注意！
>
> 如果安装双系统，还需要下载 os-prober，该工具可以检测到 Windows 的引导程序
>
> ```shell
> pacman -S os-prober
> ```
>
> 为了引导 Windows 系统，需要修改 `/etc/default/grub`，该文件追加新的一行 **GRUB_DISABLE_OS_PROBER=false**
>
> ```shell
> GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet"
> GRUB_CMDLINE_LINUX=""
> GRUB_DISABLE_OS_PROBER=false # 这一行为新添加的
> ```

## 重启系统

```shell
exit                  # 退出 chroot 环境
swapoff /mnt/swapfile # 关闭交换文件
umount -R /mnt        # 取消挂载 /mnt 
reboot                # 重新启动计算机
```

此时就已经安装好一个没有桌面环境的 ArchLinux 系统了 🎉


> 如果是安装双系统，可能重启会出现引导没有 Windows 的情况，这不碍事
> 
> 只需要重启后，重新刷新 GRUB 的配置即可，也就是下面的操作
> 
> ```shell
> grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=GRUB
> 
> grub-mkconfig -o /boot/grub/grub.cfg # 重新生成 GRUB 配置
> ```
> 
> 这也是笔者多次安装双系统所出现的情况，就是 GRUB 配置可能需要重启系统后再刷新，不然是没有用的


# 💻 配置系统

## 连接网络

登录 root 用户后，使用网络管理器 NetworkManager 来连接网络

```shell
nmcli device wifi list  # 列出可连接的 WiFi
nmcli device wifi connect "SSID" password "密码"  # 连接 WiFi
```

## 创建普通用户

日常使用 root 可能带来安全风险，因此需要创建一个普通用户，并为其设置密码

```shell
useradd -m -G wheel 用户名  # 创建用户，并为其创建家目录，将其加入 wheel 组
passwd 用户名
```

普通用户的权限又太低了，有时需要 root 权限做一些事情，为了提升权限，需要配置一个工具，就是 sudo

```shell
pacman -S sudo # 安装 sudo
```

由于该文件十分重要，所以不能使用 `vim /etc/sudoers`，而应该使用下面的命令

```shell
EDITOR=vim visudo
```

请找到下面一行，并去掉 `"%wheel ALL=(ALL:ALL) ALL"` 前面的注释，也就是修改成下面的样子

```shell
## Uncomment to allow members of group wheel to execute any command
%wheel ALL=(ALL:ALL) ALL
```

提升普通用户的权限后，就可以切换到新创建的用户了

```shell
su 用户名 # 切换到新创建的用户
```

## 安装基础包配置 pacman

安装基础的打包工具

```shell
sudo pacman -S base-devel
```

pacman 是 ArchLinux 的包管理器，负责安装、卸载、更新和查找软件包，配置下列内容可以有更好的体验

编辑 `etc/pacman.conf` 文件

```shell
sudo vim /etc/pacman.conf 
```

- 启用颜色显示和并行下载，取消 **Color** 和 **ParallelDownloads = 5** 前面的注释，也就是修改成下面的样子

   ```shell
    # Misc options
    Color
    ParallelDownloads = 5
   ```

- 启动 multilib，这可以帮助我们在 ArchLinux 中运行 Steam 和 Wine，找到下面内容并将注释取消

    ```shell
    [multilib]
    Include = /etc/pacman.d/mirrorlist
    ```

## 安装 KDE 桌面环境

这里选择安装的是 KDE 桌面，当然也可以选择其他的桌面环境进行安装

```shell
sudo pacman -Syu # 更新软件库

sudo pacman -S xorg xorg-xinit # xorg，这是所有 Linux 桌面环境的基石

sudo pacman -S plasma kde-accessibility kde-graphics kde-system kde-utilities \
				cups ffmpegthumbs noto-fonts
				
sudo pacman -Rns discover flatpak-kcm plasma-sdk # 卸载多余的软件

sudo systemctl enable sddm # 启动SDDM，它作为依赖已经自动安装，使用SDDM从登录界面启动桌面环境
```

## 安装驱动

安装声卡驱动

```shell
sudo pacman -S alsa-utils pulseaudio-alsa
```

安装显卡驱动

```shell
lspci | grep VGA # 查看显卡型号

sudo pacman -S xf86-video-intel mesa # intel 核心显卡驱动
sudo pacman -S nvidia-open nvidia-utils xf86-video-nouveau # nvidia 开源驱动
```

## 安装中文字体和输入法

安装中文字体

```shell
sudo pacman -S wqy-microhei wqy-zenhei noto-fonts-emoji ttf-dejavu \
				adobe-source-han-sans-cn-fonts adobe-source-han-sans-tw-fonts 
```

安装 Fcitx5 输入法

```shell
sudo pacman -Sy fcitx5-im fcitx5-chinese-addons
```

 (可选)安装 Fcitx5 输入法的皮肤：

```shell
 yay -S fcitx5-breeze fcitx5-material-color 
```

## 安装蓝牙图形工具

```shell
sudo pacman -S bluez bluez-utils pulseaudio-bluetooth pavucontrol pulseaudio-alsa

sudo systemctl enable bluetooth # 启动后，重启即可看到托盘的蓝牙图标
```

## 安装 yay

yay 可以让用户从庞大的 AUR 仓库中下载应用，这也是许多 Arch 教徒喜欢该系统的原因

因为 AUR 实在是太棒了，只需要一行命令，就可以快速处理软件的依赖关系，下载应用

```shell
sudo vim /etc/pacman.conf
```

添加 archlinuxcn 支持

```conf
[archlinuxcn]
SigLevel = Optional TrustAll

# 清华大学
Server = https://mirrors.tuna.tsinghua.edu.cn/archlinuxcn/$arch
```

更新镜像源并下载 yay

```shell
sudo pacman -S archlinuxcn-keyring

sudo pacman -Syyu yay
```

至此，整个 ArchLinux 的系统安装就大功告成了，现在只需执行 `reboot` 就可以进入到全新的 ArchLinux 世界了！ 🥰
