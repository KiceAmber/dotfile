#!/bin/bash
# 输出文本颜色
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'

# 输出帮助
print_help() {
	echo "Archiso auto install and configure script by ${yellow} KiceAmber ${plain}"
}

# ================ 全局变量 ==================
# 是否为 UEFI 模式 1-是 0-不是，默认为 1
IS_UEFI='1'

# ================ 安装前准备 ==================
# 检测是否为 UEFI 模式

# 检测时间并校准

# 关闭 reflector 服务

# 磁盘分区

# 手动设置 mirrorlist 列表

# 安装基本的 linux 包
