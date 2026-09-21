# 贡献指南

感谢你愿意补充这个资料库。仓库采用 **PR 流程**，改动经审阅合并后才会部署上线。

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

## 硬性要求

- **不要提交大文件**。GitHub 单文件上限 100 MB，且提交后会永久留在 git 历史里。
  PDF、录屏、压缩包请走[资源区](https://redkold.github.io/nju-cs-fe/resources/)的外部链接。
- 不要上传教材扫描版、付费课程录屏等无授权内容。
- 涉及硬性规定（名额、学分、资格线）时注明来源，并写"以官方文件为准"。
- 尚未核实的内容请标注 `⚠️ 待核对`。

## PR 描述

讲清三件事：**改了什么、为什么改、依据是什么**。
