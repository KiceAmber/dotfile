---
title: Visual Studio Code 配置记录
date: 2023-12-07 20:13:05
tags: 
  - 美化
  - 配置文件
categories: "零珠碎玉"
---

# 配置文件记录

> 偶尔需要手动修改 Visual Studio Code 的一些配置，此文章仅用于记录

Visual Studio Code 配置文件 `settings.json` 文件内容：

```json
{
    // 代码斜体设置
    "editor.tokenColorCustomizations": {
        "textMateRules": [
          {
                "scope": [
                    //following will be in italic
                    "comment",
                    "function",
                    "entity.name.type.class", //class names
                    "constant", //String, Number, Boolean…, this, super
                    "storage", //static keyword
                    "keyword" //import, export, return…
                ],
                "settings": {
                    "fontStyle": "italic bold"
                }
          }
      ]
    },
    // 开启 vim 且使用 `$HOME/.vimrc` 文件作为配置
    "vim.vimrc.enable": true,
    "vim.vimrc.path": "$HOME/.vimrc",

    "workbench.colorTheme": "Monokai Night",
    "workbench.iconTheme": "a-file-icon-vscode",
    "editor.lineNumbers": "off", // 关闭编辑器的行号显示

    // workspaceExplorer 插件配置
    "workspaceExplorer.workspaceStorageDirectory": "/home/ryan/Public/Workspace",

    // 左侧树目录父子文件的间距
    "workbench.tree.indent": 18,
    "files.autoSave": "onWindowChange",

    // 光标丝滑设置
    "editor.smoothScrolling": true,
    "editor.cursorSmoothCaretAnimation": "on",
    "editor.cursorBlinking": "smooth",
    "workbench.list.smoothScrolling": true,
    "terminal.integrated.smoothScrolling": true,
    "window.zoomLevel": 1,
    "extensions.ignoreRecommendations": true,
    "terminal.integrated.fontFamily": "'Hack Nerd Font'",
    "git.openRepositoryInParentFolders": "never",

    // terminal 终端默认设置为 zsh
    "terminal.integrated.defaultProfile.linux": "zsh",
    "terminal.integrated.profiles.linux": {
        "zsh": {
            "path": "/bin/zsh",
        }
    }
}
```

# 插件列表

## Theme

- [ ] Shades of Purple
- [ ] Omni Theme
- [ ] Monokai Night Theme

## Icon

- [ ] Atom Material Icons
- [ ] Carbon Product Icons

## Language

### Rust

- [ ] rust-analyzer
- [ ] crates 
- [ ] Rust Syntax

### Golang

- [ ] Go
- [ ] goctl

### Vue

- [ ] Vue Language Features (Volar)
- [ ] vue3-snippets-for-vscode
- [ ] Typescript Vue Plugin (Volar)


## Other

- [ ] Workspace Explorer
- [ ] Even Better TOML
- [ ] indent-rainbow
- [ ] Custom CSS and JS Loader
- [ ] TabOut