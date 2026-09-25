# 贡献指南

感谢你愿意补充这个资料库。仓库采用 **PR 流程**，改动经审阅合并后才会部署上线。

## 环境要求

只需要三样：**Node.js 18+**、**git**、**make**。
macOS 上没有 `make` 的话执行 `xcode-select --install` 即可。
检查脚本只用系统自带的工具，不需要额外安装任何东西。

## 快速开始

```bash
git clone git@github.com:RedKold/nju-cs-fe.git   # 没有写权限的话，先 Fork 再克隆自己的
cd nju-cs-fe
make install                                     # 装依赖
make branch NAME=feat/你的主题                    # 从最新 main 建分支
make dev                                         # 本地预览，改 md 自动刷新
```

改完之后：

```bash
make check                                       # 自查，不过就别提交
make pr MSG="docs: 补充夏令营经验"                 # 提交、推送，并打印 PR 链接
```

完整说明见 **<https://redkold.github.io/nju-cs-fe/guide/contributing>**。

## 常用命令

运行 `make` 会列出全部命令，最常用的几个：

| 命令 | 作用 |
| --- | --- |
| `make dev` | 本地开发服务器（热更新，5173 端口） |
| `make new` | 新建文章，自动生成骨架并提示侧边栏写法 |
| `make check` | 检查死链、漏挂页面、裸链接、大文件 |
| `make pr` | 提交并推送当前分支，给出创建 PR 的链接 |

不想用 Makefile 也可以直接用 `npm run docs:dev`、`npm run docs:build` 等脚本。

## 新增页面

侧边栏根据目录结构**自动生成**，把 `.md` 放进对应板块目录即可，不需要修改任何配置。

侧边栏显示的文字取正文的一级标题，所以**页面要有一级标题**。
想控制它在侧边栏里的位置，就在文件开头加 `order`，数字越小越靠前：

```markdown
---
order: 3
---

# 夏令营
```

`index.md` 永远排第一；没写 `order` 的排在末尾。
完整规则见 <https://redkold.github.io/nju-cs-fe/guide/contributing>。

## 硬性要求

- **不要提交大文件**。GitHub 单文件上限 100 MB，且提交后会永久留在 git 历史里。
  PDF、录屏、压缩包请走[资源区](https://redkold.github.io/nju-cs-fe/resources/)的外部链接。
- 不要上传教材扫描版、付费课程录屏等无授权内容。
- 涉及硬性规定（名额、学分、资格线）时注明来源，并写"以官方文件为准"。
- 尚未核实的内容请标注 `⚠️ 待核对`。

## PR 描述

讲清三件事：**改了什么、为什么改、依据是什么**。
