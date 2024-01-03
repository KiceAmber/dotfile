> Firefox 自定义主页

# Firefox 设置紧凑布局

地址栏输入 `about:config`，然后搜索 `compact` 关键字，将 `browser.compactmode.show` 偏好值设置为 true

执行完后，右上角右键自定义工具栏，在底下密度选择 **紧凑(Compact)** 即可

# Firefox 设置主页 CSS

## 自定义CSS 

地址栏还是搜索 `about.config`，搜索 `toolkit.legacyUserProfileCustomizations.stylesheets`，并且设置为 true

地址栏搜索 `about:support`，选择 Profile Folder，点击 Open Folder 进入 Firefox 的根目录下

创建一个 `chrome` 的文件夹，所有的自定义 CSS 脚本都会放入该文件夹下 

首先创建 `userChrome.css` 和 `userContent.css` 两个文件

访问 github 地址：https://github.com/spencerwooo/minimal-functional-fox，下载仓库的所有文件，并将其中的 `userChrome.css`、`userContent.css` 以及两个 SVG 图标 `right-arrow.svg`、`left-arrow.svg` 复制到刚刚创建的 chrome 文件夹下

最后重启 Firefox 就可以看到主题已经生效了

## nightTab 插件

在 Firefox 的扩展中搜索 nightTab 即可添加该插件
