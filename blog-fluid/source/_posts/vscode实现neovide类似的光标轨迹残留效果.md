---
title: vscode实现neovide类似的光标轨迹残留效果
date: 2023-12-08 16:38:23
tags: 
  - 美化
---

# 前言

在使用 neovim 的那会，刚刚接触到 NeoVide，顿时被其独特的光标移动特效吸引了，惊为天人

搜遍全网，然后在 reddit 上找到了一篇帖子：[neovide_alike_cursor_effect_on_vscode](https://www.reddit.com/r/vscode/comments/11e66xh/i_made_neovide_alike_cursor_effect_on_vscode/)

大佬在该帖子中展示了其使用 js 写的光标轨迹追踪的效果视频，本文章就用于记录配置过程

# 1. 下载 Custom CSS and JS Loader 插件

因为大佬使用 js 写的，所以需要将 js 代码嵌入到 vscode 的内部代码中，这个插件就可以帮忙做到这一点

# 2. 下载 dotfile 文件

从大佬的 github 仓库中下载对应的 [index.js](https://github.com/qwreey/dotfiles/blob/master/vscode/trailCursorEffect/index.js) 文件，并且放在喜欢的任何位置，只要能找到即可

# 3. 编辑 settings.json 文件

`settings.json` 文件就是 vscode 的配置文件，加入下面的内容：

```json
"vscode_custom_css.imports": [
	"file:///path/to/your/"
],
```

将 `file:///path/to/your/` 替换成刚刚下载好的 index.js 文件位置，比如我这里的是：

```json
{
    ...

    "vscode_custom_css.imports": [
        "file:///home/username/Documents/dotfile/vscode/trail-cursor-effect/index.js"
    ],

    ...
}
```

# 4. 启用 Custom CSS and JS 插件

按下 Ctrl + Shift + P 弹出命令窗口，输入 `Enable Custom CSS and JS`，回车启用刚刚下载好的插件即可

> 我这里是 ArchLinux，vscode 的下载位置是在 `/opt/visual-studio-code-bin` 所以，我还需要将其目录权限修改一下，不然以我的普通用户权限，是修改不了 vscode 的底层文件的
> 
> ```shell
> sudo chmod -R o+w /opt/visual-studio-code-bin
> ```

这里提示要重启，建议是自己手动关闭窗口然后再重新打开，然后可能会提示 vscode 已损坏，这个是因为修改了 vscode 的底层文件自动弹出提示的，直接点击弹窗右上角的小齿轮，选择永不弹出即可

这样在 vscode 中实现光标轨迹的效果就实现了，而且非常建议打开 vscode 的 smooth 相关设置，体验会非常丝滑：

![](https://z1.ax1x.com/2023/12/08/pi2VBi6.png)

这样 vscode 配合上 nvim 插件，开发体验非常好 🥳
