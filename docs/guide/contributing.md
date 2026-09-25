---
order: 4
---

# 如何贡献

仓库采用 **PR（Pull Request）流程**：任何人都可以提改动，但改动会先提交到分支，
经审阅合并进 `main` 之后才会上线。所以你不会因为手滑改坏线上站点。

## 先确认你的身份

| 身份 | 能否直接推本仓库 | 做法 |
| --- | --- | --- |
| 协作者（被邀请过） | 可以 | 直接克隆本仓库，建分支提 PR |
| 其他同学 | 不可以 | 先 **Fork** 到自己账号，再克隆自己的 fork |

不确定的话就先 Fork，这条路一定走得通。

## 环境要求

| 工具 | 说明 |
| --- | --- |
| Node.js 18+ | 构建站点必需，用 `node -v` 检查版本 |
| make | 执行本仓库的维护命令。macOS 自带；若提示 `command not found`，执行 `xcode-select --install` |
| git | 版本控制 |

除此之外**不需要额外安装任何工具**。检查脚本只用系统自带的 `grep`、`awk`、`find`，
不需要装 ripgrep 之类的第三方命令行工具。

## 推荐流程：用 Makefile

### 第一步：把仓库弄到本地

协作者：

```bash
git clone git@github.com:RedKold/nju-cs-fe.git
cd nju-cs-fe
```

没有写权限的同学，先在 GitHub 页面点右上角 **Fork**，然后克隆自己的 fork，
并把原仓库加为 `upstream`：

```bash
git clone git@github.com:<你的用户名>/nju-cs-fe.git
cd nju-cs-fe
git remote add upstream git@github.com:RedKold/nju-cs-fe.git
```

> `make branch` 会自动识别 `upstream`，有它的时候就从原仓库拉取最新代码，
> 保证你是在最新版本上改的。

### 第二步：装依赖并建分支

```bash
make install                       # 装依赖，只需要一次
make branch NAME=feat/xia-ling-ying
```

分支命名建议：

| 前缀 | 用途 |
| --- | --- |
| `feat/` | 新增内容 |
| `fix/` | 修正错误 |
| `docs/` | 纯粹的文字调整 |

### 第三步：边写边看

```bash
make dev          # 启动后浏览器打开 http://localhost:5173，改 md 会自动刷新
make new          # 新建文章，自动生成骨架并提示侧边栏该写什么
```

> **新增文件后要在终端里按一下 `r`。**
> 侧边栏是在开发服务器启动时根据目录生成的，VitePress 不会因为新增 `.md` 而重建它。
> 结果是：新文件的 URL 能直接访问，但侧边栏要等重启才会出现这一条。
> 在运行 `make dev` 的终端里按 `r` 重启即可（按 `h` 可以看到全部快捷键）。
>
> 这只影响本地预览。`make check` 和 `make pr` 都会重新构建，线上侧边栏一定是完整的。

### 第四步：自查并提交 PR

```bash
make check        # 先自查：死链、漏挂页面、裸链接、大文件
make pr MSG="docs: 补充夏令营经验"
```

`make pr` 会做完这几件事：跑一遍检查 → 提交 → 推送分支 → **打印创建 PR 的链接**。
点开那个链接，填好标题和说明，提交即可。

## 新增页面不用改配置

侧边栏和顶部导航由 `docs/.vitepress/sidebar.ts` **根据目录结构自动生成**。
你只要把 `.md` 放进对应板块目录，它就会自动出现在侧边栏，不需要编辑任何配置文件。

### 侧边栏显示的文字

按下面的优先级取，第一个取到就用它：

1. frontmatter 里的 `title`
2. 正文第一个一级标题（`# xxx`）
3. 文件名（兜底，尽量避免，否则导航里会出现 `summer-camp` 这种英文文件名）

所以**页面一定要有一级标题**，`make check` 会帮你把关。

### 排序

- `index.md` 永远排第一
- 其他页面按 frontmatter 里的 `order` 从小到大排
- 没写 `order` 的排在写了 `order` 的后面，它们之间按标题排序

一个页面的开头通常长这样：

```markdown
---
order: 3
---

# 夏令营
```

### 什么时候用 title

有些页面的正文标题适合带语气或标语，但**侧边栏需要简短、克制**。
这时用 `title` 单独指定导航文字，正文标题保持原样：

```markdown
---
title: 出国总览
order: 1
---

# 未经过修缮！

（正文……）
```

### 新增整个板块

只有这种情况才需要动 `sidebar.ts`，在 `SECTIONS` 数组里加一行：

```ts
{ dir: 'lab', text: '实验室', group: '升学' }
```

`dir` 是 `docs/` 下的目录名，`text` 是显示的名字，`group` 可选 ——
填了就会收进顶部导航的下拉菜单，`group` 相同的归为一组。
记得给新板块建一个 `index.md`，`make check` 会检查这一点。

### 跨板块链接

侧边栏底部的「相关页面」分组是唯一需要手工维护的部分，
写在 `sidebar.ts` 顶部的 `RELATED` 里。这类链接很少变动，
如果指向的页面不存在，`make check` 会报错。

## 不用 Makefile 也行

Makefile 只是把几条命令包了一层，你完全可以手工来：

```bash
npm install
npm run docs:dev          # 开发预览
npm run docs:build        # 构建，会顺带校验死链
git switch -c feat/xxx
git add -A && git commit -m "docs: 补充夏令营经验"
git push -u origin feat/xxx
```

推送后 GitHub 仓库首页会出现 **Compare & pull request** 按钮，点它即可。

## PR 描述怎么写

审阅的人需要快速判断改了什么、依据是什么。一段话讲清这三点就够：

```text
改了什么：在推免板块新增了 2026 年夏令营时间线
为什么：我今年刚经历完，整理出来给下一届参考
依据：各校研究生院官网公告，链接已附在文中
```

## 内容规范

- **标注来源和年份**。经验类内容写清作者和年份，年份越新参考价值越高。
- **没核实的要标出来**。用 `⚠️ 待核对`，不要让读者误当成结论。
- **硬性规定只写"以官方文件为准"**，并给出来源链接。
- **不要提交大文件**。PDF、录屏、压缩包一律走[资源区](/resources/)的外部链接，
  GitHub 单文件上限 100 MB，且提交后极难清除。
- **不要上传无授权材料**，比如教材扫描版、付费课程录屏。
- 涉及具体老师的评价请就事论事。

## 审阅与合并

维护者会检查内容和格式，可能会留言请你补充依据。合并进 `main` 之后，
GitHub Actions 会自动构建并部署，约 1～2 分钟线上生效。

如果 PR 放了很久没人理，可以直接在 PR 里 @ 维护者催一下。

## 给维护者

```bash
make sync                          # 切回 main 并拉取最新代码
make publish MSG="docs: ..."        # 只允许在 main 上执行，直接上线
```

`make publish` 在其他分支上会直接拒绝，避免绕过 PR 流程。

> **建议在 GitHub 上开启分支保护**：`Settings → Branches → Add branch protection rule`，
> 规则填 `main`，勾选 `Require a pull request before merging`。
> 这样即使有人有写权限，也无法绕过 PR 直接推 main。
